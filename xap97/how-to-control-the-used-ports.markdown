---
layout: post
title:  How to Control the Used Ports
categories: XAP97
parent: networking-how-tos.html
weight: 700
---

{% summary %}Default ports used by the space, container, and Jini Lookup Service, and how to configure them. {% endsummary %}

# Overview

GigaSpaces space and client components open different ports in various situations. The following list describes the different ports used by GigaSpaces and how these can be modified:

{% refer %}Learn how to **[set GigaSpaces over a firewall](./how-to-set-gigaspaces-over-a-firewall.html)**.{% endrefer %}

{: .table .table-bordered}
| Service | Description | Configuration Property| Default value |
|:--------|:------------|:----------------------|:--------------|
|Lookup Service listening port|Used as part of the unicast lookup discovery protocol.|`com.sun.jini.reggie.initialUnicastDiscoveryPort` System property|XAP 6: **4162**{% wbr %}XAP 7: **4164**{% wbr %}XAP 8: **4166**{% wbr %}XAP 9: **4170**{% wbr %}XAP 9.5: **4174**|
|LRMI listening port|Used with client-space and space-space communication. |`com.gs.transport_protocol.lrmi.bind-port` System property. |variable , random|
|RMI registry listening port |Used as an alternative directory service.| `com.gigaspaces.system.registryPort` System property|10098 and above.|
|RMI registry Retries |Used as an alternative directory service.| `com.gigaspaces.system.registryRetries` System property|Default is 20.|
|Webster listening port|Internal web service used as part of the application deployment process. |`com.gigaspaces.start.httpPort` System property|9813|

- When starting a space and providing the port as part of the URL - i.e. `java://localhost:PORT/container/space` - the specified port will be used both for the RMI registry listener and also for the container to register into the RMI registry.
- The Jini Lookup Service uses unicast and multicast announcements and requests.
- The **multicast** discovery protocol uses ports 4170.
- You can **completely disable multicast announcement traffic**. Refer to the [Lookup Service Configuration](./lookup-service-configuration.html) or [Setting GigaSpaces Over Firewall](./how-to-set-gigaspaces-over-a-firewall.html) sections for more details.
- When running a clustered space using replication via multicast, additional ports are used.

{% comment %}
| Webster | linux: `NO_HTTP` Windows: `noHTTP` | `0` | `\-Dcom.gigaspaces.start.httpPort=0 \-Dcom.gigaspaces.start.httpServerRetries=20`
   | [How to Control the Used Ports](webster.xml) | Additional properties can also be overridden (for example: `httpServerRetries`, `hostAddress`)

   `httpServerRetries` retries N-1 consecutive ports if the initial port is used (relevant if the initial port is different than zero). Default is 20.
   |
| JMX | linux: `NO_JMX` Windows: `noJMX` | `10098` | `\-Dcom.gigaspaces.system.registryPort=10098` | XML override using
   `com.gigaspaces.start.jmx.svcDesc` | `registryRetries` retries N-1 consecutive ports if the initial port is used (for example: `10098`, `10099`, `..\[10098+(N-1)\]`) |
{% endcomment %}
