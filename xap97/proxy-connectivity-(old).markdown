---
layout: post
title:  Proxy Connectivity (Old)
categories: XAP97
parent: tuning-gigaspaces-performance.html
weight: 130
---

{% summary %}Client Proxy Connectivity and reconnection options{% endsummary %}

{% warning title=This page describes the old proxy router, which is disabled starting 9.0.1. For information regarding the new proxy router, refer to [Proxy Connectivity](./proxy-connectivity.html) %}
{% endwarning %}

# Overview

A client proxy object used by the application to interface with the data-grid. The application is unaware of it , but under-the-hood it maintains at the client side a mapping of the locations for all the data-grid members (logical partitions) and their physical location. Using this information it routs the requests (read/write) to the correct target logical partition or perform parallel map-reduce style activity when needed (readMultiple/writeMultiple/Execute).

The master location of the logical partitions mapping is the [Lookup Service](./the-lookup-service.html). It is responsible to update the client proxy with the latest location of each logical partition when the proxy bootstrap itself, when the system scales or when there is a failure that triggers a promotion of a backup into a primary and the creation of the new backup instace.

Each space operation on a data-grid cluster is routed to a single member or multiple cluster members. The routing done based on the operation type and [data partitioning](./data-partitioning.html) policy. To make this routing possible and efficient, the client proxy holds a set of [remote stubs](http://download.oracle.com/javase/1.5.0/docs/guide/rmi/spec/rmi-stubs22.html) to the relevant cluster members. The proxy connectivity policy determines which remote proxy members should be constructed at client startup, and how to monitor them to control the failover response time and reconnection behavior. The client proxy monitors the cluster members in two ways: checking existing stubs and locating members that does not have stubs created for yet.

# Client Proxy Connectivity Configuration

The proxy Connectivity settings should be specified as part of the **space configuration** (server side). You may specify these as part of the [Space Component](./the-space-component.html#Reconnection) or via API.  The settings are loaded into the client side once it connects to the space. Client proxy connectivity settings controlled via the following settings:

{: .table .table-bordered}
|Property|Description|Default|Unit|
|:-------|:----------|:------|:---|
|space-config.proxy-settings.connection-monitor|Determine the proxy monitoring policy for space cluster members .Options:{% wbr %}all - Full monitoring. The client proxy establishes a connection with all cluster members immediately at startup, and all the cluster members are monitored as long as the client proxy is alive. This policy should be used when failover time is important, and needs to be minimal.{% wbr %}on_demand - Monitoring on demand. All the connections to remote spaces are established on demand only, and once the connection is established, the connected space and its backups are monitored by the clustered proxy. This policy should be used when only part of the cluster is used, for example a scenario when all client operations go to the same partition.{% wbr %}none - No monitoring. All the connections to remote spaces are established on demand only, and no monitoring is done. This policy eliminates the monitoring overhead completely - no unnecessary lookups or pings, but it can also increase the failover time.|all| |
|space-config.proxy-settings.ping-frequency|Specify the ping frequency for cluster members that were already found by the proxy. Replacing the previous `liveness-monitor-frequency` system property used with old versions.|10000 |ms|
|space-config.proxy-settings.lookup-frequency|Specify the lookup frequency for cluster members that were never looked up by the proxy, or never joined the cluster. Replacing the previous `liveness-detector-frequency` system property used with old versions.|5000 |ms|
|space-config.proxy-settings.connection-retries|Specify the retry count for establishing a connection with unavailable cluster member before failing the operation. |10 for PUs, and 20 for Elastic PUs| |
|cluster-config.groups.group.fail-over-policy.fail-over-find-timeout|Specify the wait time between each retry. |2000|ms|

An optimization was applied to the monitoring algorithm, to not check the available spaces if they are constantly in use, i.e. constantly handling user operations.

# Client Proxy Reconnection

To allow a space client performing the different space operation (read,write,take,execute) to reconnect to a space cluster that has been **completely shutdown** and restarted, make sure you increase the `space-config.proxy-settings.connection-retries` parameter to have a higher value than the default. A value of `100` will provide you several minutes to restart the space cluster before the client will fail with `com.j_spaces.core.client.FinderException`.

## Reconnection with Notify Registration

To allow a client using notifications (using the [Session Based Messaging API](./session-based-messaging-api.html) or the [Notify Container](./notify-container.html)) to reconnect and also re-register for notifications, use the `LeaseListener`. See the [Re-Register after complete space shutdown and restart](./notify-container.html#Re-Register after complete space shutdown and restart) section for details.

{% tip %}
See the [Resending Notifications after a Space-Client Disconnection](./notify-container.html#Resending Notifications after a Space-Client Disconnection) section for space-client disconnection behavior.
{% endtip %}

## Reconnection with Blocked Operations

When using blocked operations such as read operation with a timeout>0, take operation timeout>0 or [Polling Container](./polling-container.html), GigaSpaces can't guaranty the read/take timeout will match the specified timeout once a client reconnects to a space that was shutdown and restarted (or failed and client routed to the backup instance).

Once the client reconnects, the entire read operation is reinitiated, ignoring the amount of time the client already spent waiting for a matching object before the client was disconnected.

## Reconnection with Local Cache/View

For information regarding local cache/view reconnection, refer to [Local Cache](./local-cache.html) or [Local View](./local-view.html).

# Unicast Lookup Service Discovery

If you are using [Unicast lookup service discovery](./how-to-configure-unicast-discovery.html) you should set the `com.gigaspaces.unicast.interval` system property to allow the client to keep searching for the lookup service in case it was terminated and later restarted while the client was running. See the [How to Configure Unicast Discovery](./how-to-configure-unicast-discovery.html#Configuring lookup discovery intervals) for details.

# Inactive Space retries

When a primary space partition fails and a backup space partition is being elected as a primary, client proxy will recognize the primary failure and route the requests to the backup. Election of a backup to primary is done using  active election process and this is not instantaneous (might take few seconds based on the active election configuration parameters). Any client requests directed to this partition during this time will still complete because there is a retry logic for recognizing `com.gigaspaces.cluster.activeelection.InactiveSpaceException` conditions, where proxy retries the same operation until the space becomes active/primary. Retry limits and gap between retries can be configured using following system properties on the client side:

{: .table .table-bordered}
| Property (client side) | Description | Defualt value|
|:-----------------------|:------------|:-------------|
| `com.gs.client.inactiveRetryLimit` | Number of retires on operation, waiting for one of the servers to become active after Active election. | 20 |
| `com.gs.failover.standby-wait-time`| Retry backoff sleep time(ms). Between retries while waiting for one of the servers to become active after Active election. | 1000 ms|
