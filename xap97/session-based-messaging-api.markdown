---
layout: post
title:  Data Events
categories: XAP97
parent: notify-container.html
weight: 100
---

{% summary   %}Using Data Event Sessions to receive events when data changes in the space{% endsummary %}


# Overview

In some cases, applications wish to be notified when certain data changes in the space (For example, a trader desk application is notified when a quote stock object is modified, or when a matching engine removes/updates a matched order). The space lets clients register for matching events inside the space, and notifies them whenever a matching event occurs.

{% tip %}
This page describes the low level API for data events. It is preferable to use [Notify Container](./notify-container.html) instead, which provides a high-level abstraction of event processing. 
{% endtip %}

# Usage

An event registration is composed of the following:

* The *listener* which should be triggered when the event occurs. 
* The *space* which should monitor data changes and trigger the events.
* The *template* or *query* which the space used to determine if an event is relevant for the listener.

## Implementing an Event Listener

To implement an event listener simply create a class which implements `RemoteEventListener`. For example:

{% highlight java %}
public class MyListener implements net.jini.core.event.RemoteEventListener {
    @Override
    public void notify(net.jini.core.event.RemoteEvent theEvent) {
        EntryArrivedRemoteEvent spaceEvent = (EntryArrivedRemoteEvent)theEvent;
        MyData myData = (MyData)spaceEvent.getObject();
        // TODO: Process the event.
    }
}
{% endhighlight %}

The `RemoteEvent` argument encapsulates information about the event. Since this event was triggered by the space, it can be safely cast to the space-specific `EntryArrivedRemoteEvent` class, which provides more information, including the object which triggered the event.

## Registering an Event Listener

Event registrations are created and managed using a `DataEventSession`. To create a session, simply invoke the `newDataEventSession()` method in `GigaSpace`. Once the session is created, use the `addListener()` method with the template and callback listener to register the event listener. For example:   
{% highlight java %}
public void register(GigaSpace gigaSpace, SQLQuery<MyData> query, RemoteEventListener listener) {
    DataEventSession session = gigaSpace.newDataEventSession();
    session.addListener(query, listener);
}
{% endhighlight %}

This creates a data event session with default configuration settings. If you need different settings, create an `EventSessionConfig`, set the relevant settings and use it to create the session. For example, to create a *FIFO* event session:  
{% highlight java %}
EventSessionConfig sessionConfig = new EventSessionConfig();
sessionConfig.setFifo(true);
DataEventSession session = gigaSpace.newDataEventSession(sessionConfig);
{% endhighlight %}

## Canceling Registration and Closing the Session

An event registration consumes resources on both client and server. It is recommended to explicitly remove event registrations when they are no longer required. 

### Canceling an Event Registration

The `addListener()` method which creates the registration returns an object of type `EventRegistration`, which can be used to remove the listener:

{% highlight java %}
EventRegistration registration = session.addListener(query, listener);
// ...
session.removeListener(registration);
{% endhighlight %}

### Closing the Session

If the entire session is no longer needed, instead of removing the active registrations one-by-one you can simply call the session's `close()` method to close all active registrations.

{% note %}
A closed session cannot register new listeners - You need to create a new session in order to register for new events.
{%endnote%}

# Event Types

By default the event listener is registered for all the space operations, but many times only some of the operations are relevant (e.g. only writes). The listener can be subscribed to a specific operation using an overload of the `addListener()` method. For example, to subscribe for *write* events:

{% highlight java %}
session.addListener(query, listener, NotifyActionType.NOTIFY_WRITE);
{% endhighlight %}

If the listener is interested in several operation types, it can mask them together in a single registration. For example, to register for *write* and *take* events: 

{% highlight java %}
NotifyActionType notifyType = NotifyActionType.NOTIFY_WRITE.or(NotifyActionType.NOTIFY_TAKE);
session.addListener(query, listener, notifyType);
{% endhighlight %}

{% tip %}
 When masking multiple event types together, the listener can check what triggered the event using `EntryArrivedRemoteEvent.getNotifyActionType()`.
{% endtip %}
 

The available event types are:

{: .table .table-bordered}
| NotifyActionType | Description |
|:--------|:------------|
|`NOTIFY_WRITE`| A matching entry has been written to the space.|
|`NOTIFY_UPDATE`| A matching entry has been updated in the space.|
|`NOTIFY_TAKE`| A matching entry has been removed from the space by a `take` operation.|
|`NOTIFY_LEASE_EXPIRATION`| A matching entry has been removed from the space because its lease has expired.|
|`NOTIFY_MATCHED_UPDATE`|A non-matching entry has been updated and now matches.|
|`NOTIFY_REMATCHED_UPDATE`|A matching entry has been updated and continues to match.|
|`NOTIFY_UNMATCHED`|A matching entry has been updated and no longer matches.|
|`NOTIFY_WRITE_OR_UPDATE`| A combination of `NOTIFY_WRITE` and `NOTIFY_UPDATE`.|
|`NOTIFY_ALL`| A combination of `NOTIFY_WRITE`, `NOTIFY_UPDATE`, `NOTIFY_TAKE` and `NOTIFY_LEASE_EXPIRATION`.|

{%warning%}
`NOTIFY_UPDATE` cannot be used with `NOTIFY_MATCHED_UPDATE` and `NOTIFY_REMATCHED_UPDATE`, since they are overlapping.
`NOTIFY_ALL` is deprecated and should not be used. The reason is that as the product evolves and new event types are added, they are not included in `NOTIFY_ALL` to preserve backward compatibility, and the name `ALL` is misleading.
 Notifications for expired objects sent both from primary and backup space (when using backups).
{%endwarning%}

# FIFO

By default, there is no guarantee on the order of data events. To enforce FIFO ordering, use `EventSessionConfig.setFifo(true)`. For example:

{% highlight java %}
EventSessionConfig sessionConfig = new EventSessionConfig();
sessionConfig.setFifo(true);
DataEventSession session = gigaSpace.newDataEventSession(sessionConfig);
{% endhighlight %}

When a session is configured to be FIFO, all the event listeners registered through it will be FIFO.

When FIFO is not set, the event listener is often invoked concurrently for different events, for efficiency. When FIFO is enabled, though, all events are queued in a single dispatcher thread and are processed sequentially. Note that while this synchronization is required to ensure the correct order, it may also affect performance as multiple events cannot be processed simultaneously. 

{%note%}
When using a partitioned cluster, FIFO is maintained per-partition and not for the entire cluster.
{%endnote%}

# Batching

By default, whenever the space executes an operation which triggers an event, it immediately dispatches the event to the client. When there's a large amount of events, this approach burdens the network, since dispatching the events one at a time incurs a remote call per event.

Instead, a listener can instruct the space to gather events into batches before dispatching, thus reduce the amount of remote calls the space needs to perform in order to deliver the events to the client. The downside is potential latency issues, since events are not dispatched immediately to the client - they are kept in the space waiting for other events to join the batch.

To enable batching use `DataEventSession.setBatch(int size, long time)`. Size determines how many entries the space will try to gather before dispatching the batch, and time determines the maximum time (in milliseconds) it will wait for the batch to fill (i.e. if *time* elapsed and batch is smaller than *size*, send the batch anyway). This lets the user balance throughput and latency. For example, to set the batch size to 1000 entries and max timeout of 50 milliseconds:

{% highlight java %}
EventSessionConfig sessionConfig = new EventSessionConfig();
sessionConfig.setBatch(1000 /* batch size */, 50 /* batch time */);
DataEventSession session = gigaSpace.newDataEventSession(sessionConfig);
{% endhighlight %}

When a session is configured to for batching, all the event listeners registered through it will use those batch settings.

# Disconnections

When a client executes a "regular" space operation and the space is disconnected, the operation fails with an exception. Data events, however, are asynchronous by nature, which means detecting network problems is more complicated. This problem takes different forms in the client and the server: 

### The Client Side

When the client does not receive events, it cannot tell if it is because the server is unreachable, or because there are no events to be delivered. Some clients require a separate trigger to inform them when the server is disconnected so they can act upon it.

### The Server Side

When an event cannot be delivered to a client (network failure or a dead client), the space retries to send it several times (configured using `space-config.notifier-retries`). If it still fails the event registration is removed. 

If there are no events to send, the event registration will live on. Note that each event registration consumes resources from the server, since it needs to inspect data operations to check if an event should be triggered. Such stale connections can slowly amount and slow down the server. Some applications require a mechanism to automatically detect and remove such stale registrations. 
 
## Auto Renew

The Auto Renew mechanism simplifies detecting disconnections on both client and server. When Auto Renew is enabled, event listeners are registered with a limited lease (instead of the default permanent registration), which the client automatically renews periodically. If the client disconnects from the server for a long period, the event registration's lease will expire at the server, which will cause the server to remove it.

In addition, when the client enables Auto Renew, it can provide an (optional) separate listener which will be triggered when automatic lease renewal fails.

To enable Auto Renew, use `EventSessionConfig.setAutoRenew(boolean, net.jini.lease.LeaseListener)`. For example:

{% highlight java %}
EventSessionConfig sessionConfig = new EventSessionConfig();
LeaseListener leaseListener = new MyLeaseListener();
sessionConfig.setAutoRenew(true, leaseListener);
DataEventSession session = gigaSpace.newDataEventSession(sessionConfig);
{% endhighlight %}

Note that the `LeaseListener` argument is optional, and is intended for receiving notifications when the session cannot be renewed. If you do not need it you can pass `null` instead. 

# Reliability

## Active - Passive (primary - backup) 

When running a fault-tolerant cluster (`primary-backup` or `partitioned-sync2backup` cluster schemas), it is important to understand that data is replicated between the primary and backup in a synchronous manner, but notifications are dispatched to the client in an asynchronous manner. Since the backup space is running in stand-by mode, it is unaware of the notifications that have been sent by the primary space, nor the acknowledgment that the recipients clients provided when receiving the events. This means that when a primary fails and the backup takes over, some notifications might be lost.

To ensure no notifications are lost during the failover period, use *durable notifications*:

{% highlight java %}
EventSessionConfig config = new EventSessionConfig();
config.setDurableNotifications(true);
DataEventSession session = gigaSpace.newDataEventSession(config);
{% endhighlight %}

Durable notifications are based on the same replication mechanism that is used to replicate data, and as such have some different semantics regarding other `EventSessionConfig` parameters. For more details see [Durable Notifications](./durable-notifications.html).

## Active - Active

When deploying a replicated space, you might want to replicate notify registration from the source space (primary) to the replica (backup space), allowing the replica space to continue and send notifications in case the source space failed.

Receiving events occurs as a result of data replication, and not directly from a client-space operation. This is popular in WAN-based applications, where a remote client running in the remote site wants to be notified when an operation occurs in the source space, without getting the actual notification from the remote source space, but from a replica space that is located at its local site.

- `replicate-notify-templates` -- boolean value. Set to `true` if you want to make notification templates available in the target space.
- `trigger-notify-templates` -- boolean value. Set to `true` if you want to trigger matching notification templates when Entries are written to the space, because of replication (and thus causing remote events to be generated and sent to the notify template listeners). If set to `true`, triggering occurs; if set to `false`, triggering does not occur.

The replication settings allows replicating notification registration, and the ability to trigger events that are a result of replication (and not a direct client operation) from a source space.

Here is the system behavior when using these options:

{: .table .table-bordered}
| Replicate Notify Template Setting | Trigger Notify Template Setting | Description |
|:----------------------------------|:--------------------------------|:------------|
| `true` | `false` | The client gets notifications from the master space while it is active after registration.{% wbr %}If failover has been configured, it gets notifications from the replica space when the master space fails. |
| `false` | `true` | The client gets notifications only from the spaces it registered to for notifications.{% wbr %}A notification occurs when data has been delivered to the space, either by a client application, or from the replication. |
| `true` | `true` | The client gets notifications from all clustered spaces after registration.{% wbr %}The client gets multiple notifications for every space event. |
| `false` | `false` | The client gets notifications only from the spaces to which it registered.{% wbr %}The client does not get notifications from spaces that received their data by replication. |

Replicated notify templates and triggered notify templates are orthogonal. However, if you enable them both, you should be aware that for each Entry that matches the notify template and is replicated to another space, you get an event.

This might result in more events than you initially intended. You can use the source of the event to check which space triggered it.
   
# Advanced 

## Slow Consumer

The [Slow Consumer](./slow-consumer.html) mechanism allows GigaSpaces to identify clients that cannot receive events and cancel their notify registration. This avoids system instability and out of memory problems.

## Custom Filters

Sometimes filtering events by template and operation type is not enough, and user-defined code is required. For information about implementing user-defined filters for data events refer to [Custom filters](./custom-data-event-filters.html).

## Stale Notify Registration

If many clients with active event registrations are terminating abnormally, the space might need some time to detect all stale clients and their notify registrations, delaying notification delivery to clients which are still connected. The root cause of this behavior is the thread pool within the space engine that is responsible for delivering events to clients. When all pool threads are fully consumed, notification delivery time suffers, due to the time it takes to detect and remove all stale registrations.

{% refer %}To configure the notification thread pool size set the `space-config.engine.notify_min_threads` and `space-config.engine.notify_max_threads` space properties. See the [Scaling Notification Delivery](./notify-container.html#Scaling Notification Delivery) for details.
{% endrefer %}

## Notification Lease Time (Deprecated)

Under the hood, event registrations are stored in the space with a lease, which defaults to `Lease.FOREVER`. It is possible to register the event listener with a custom lease, in which case the event registration is automatically removed when the lease expires. 

## Communication Type (Deprecated)

In previous versions data event sessions could be configured to use `unicast` or `multiplex` connections, `unicast` being the default. Recently `multiplex` has been enhanced to the point there is no added value in using `unicast` anymore. Starting 9.7 the default is `multiplex` and `unicast` has been deprecated.  