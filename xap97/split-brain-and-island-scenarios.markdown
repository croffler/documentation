---
layout: post
title:  Split Brain and Island Scenarios
categories: XAP97
parent: failover-detection-and-tuning.html
weight: 100
---

{% summary %}About Split-Brain and "Islands" scenarios, ways to detect and avoid them.{% endsummary %}

# "Split Brain" Scenario - Overview

In order to determine how to monitor/detect and handle a Split Brain scenario, you need to first understand how our system works.

{% infosign %} Attached is another [**presentation**](/presentation_files/Service-grid-FDH%20and%20SplitBrain.pdf) which will illustrate it. For more general details and definition of the Split-Brain please refer to [Split-Brain and Active Election - General Definition](./split-brain-and-active-election---general-definition.html) page.

There are 2 different mechanisms which deals with failover scenarios (note there is a difference between version 6.6 and 7.x):

1) **GSM Processing Unit FaultDetection Handler**: once a GSM detects that one of the PU's it is managing is no longer available (the GSM pings each PU from time to time to verify they are active using keep-alive algorithm) it relocates the PU to another available GSC. More
[information on the GSM PU Fault Detection Handler](./configuring-the-processing-unit-sla.html#ConfiguringtheProcessingUnitSLA-MonitoringtheLivenessofProcessingUnitInstances) is available.

2) **Active Election mechanism**:
This is a mechanism which basically [controls the failure detection of a primary space and the process of moving a backup space into a primary space state](./split-brain-and-active-election---general-definition.html).

Here are some examples for a common deployment and the expected behavior.

In one scenario, we have two machines, each with a single GSA, GSC, GSM, and LUS, and deploying a primary backup cluster.

- The GSM FaultDetection mechanism will not perform any relocation since there is only one GSC on each machine and you have the limitation of max-per-machine and max-per-vm set to 1.
- The active election mechanism will move the backup space into a primary and once the network is reconnected, likely there will initially be 2 partitions marked as primaries, but the split brain controller component will kick in and manage to recover the cluster eventually back to the consistent state.

Having one specific primary machine and one specific backup machine could be achieved by using [Zone configurations](./configuring-the-processing-unit-sla.html).

{% infosign %} Bear in mind that once a failover occurs, the backup space will become a primary even though it is located in a backup zone. You will have to manually relocate the spaces back to their originally-targeted primary machines.

{% infosign %} This [SpaceModeTest.java source](/download_files/SpaceModeTest.java) file is an example of how to determine the status of your spaces using the [Administration and Monitoring API](./administration-and-monitoring-api.html).

# Islands

In events of network or failures, the system might get into unexpected behavior, also called Islands, which are extreme and not yet supported. Here are two scenarios when you might be dealing with islands in the system:

1. When you disconnect one of the GSMs which is managing some of the PUs, and reconnect it again. The GSM (that was still a primary) tried to redeploy the failed PUs.

It depends which of the two GSMs is the primary at the point of disconnection. If the primary GSM is on the island with the GSCs, its backup GSM will become a primary until the network disconnection is resolved. When network is repaired, the GSM will realize that the 'former' primary is still managing the services, and return to its backup state.

But if it was the other way around - and the primary GSM lost connection with its PUs either due to network disconnection or any other failure - it will behave as primary and try to redeploy as soon as a GSC is available. That will lead obviously into inconsistent mapping of services and an inconsistent system.

1. A more complex form of "islands" would be if on both islands GSCs are available, leading both GSMs to behave as primaries and deploy the failed PUs. Reconciling at this point will need to take data integrity into account.

{% infosign %} The only recommendation at this point would be to manually reconcile the cluster. Kill the GSM, with only one remaining managing GSM, reload the GSCs hosting the backup space instances, and in the end, load a backup GSM.

# Common Causes For a Split-Brain

Below are the most common causes for Split-Brain scenarios and ways to detect them.

- **JVM Garbage Collection spikes** - when a full GC happens it "stops-the-world" of both the GigaSpaces and application components (and holding internal clocks and timing) and external interactions.
    - Using JMX or other monitoring tools you can monitor the JVM Garbage Collection activity. Once it gets into a full GC of longer than 30 seconds you should be alerted. In XAP 6.6 (and not in 7 or 8) there was a parallel keep-alive mechanism that was pinging the services for constant availability. That mechanism was sensitive for short GC spikes of even few dozens of seconds to mark the service as not available and as a result start another redundant service.
    - Using XAP 7.x and later - The GC keep-alive detection was removed therefore the GC as itself will not cause a split brain (unless it lasts for minutes). You can use the Admin API which uses the JMX JVM measurements and can fetch the full GC events for you. If the GC takes more than 10 seconds, it will be logged as a warning in the GSM/GSC/GSA log file.

- **High (>90%) CPU utilization** - As discussed, that can cause to various components (also external to GigaSpaces) to strive for CPU clock resources, such as keep alive mechanisms (which can miss events and therefore trigger initialization of redundant services or false alarms), IO/network lack of available sockets, OS fails to release resources etc. One should avoid getting into scenarios of constant (more than a minute) utilization of over 90% CPU.
    - You can use the out-of-the-box CPU monitoring component (which uses [SIGAR](http://www.hyperic.com/products/sigar)) for measuring the OS and JVM resources. It is easily accessible through the GigaSpaces Admin API.

- **Network outages/disconnections** - As discussed, disconnections between the GSMs or GSMs and GSCs can cause any of the GSMs to get into what is called "islands".
    - You should be using a network monitoring tool to monitor network outages/disconnections and re connections on machines which run the GSMs and GSCs. Such tool should report and alert on exact datetime of the event.

{% infosign %} Please refer to [Suggested Monitoring Tools](./suggested-monitoring-tools.html) section for more details on recommended tools.
