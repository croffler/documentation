---
layout: post
title:   FAQ
categories: XAP97
parent: multi-site-replication-over-the-wan.html
weight: 1000
---

# FAQ

- **What's the Replication flow?**
Replications starts with the local site cluster. Updates in the form of replication redo log packets are sent to the local delegator in an async manner which in turn writes them to the appropriate Sink(s) in a sync manner. This sink will perform operations corresponding to these packets on its local cluster.

- **What happens when Gateway fails or is restarted?**
Gateway component is stateless and does not save any state. When this PU is missing because of a failure (hardware, OS or process failure), GSM will restart the PU in a available container. Once it is active, it will start replicating the changes that where it left off.

- **What if two clients are writing data into a local cluster at the same time? Are these resolved by conflict resolution functionality?**
Data written to the same site by concurrent clients should be handled using transactions and appropriate isolation levels. Conflict Resolution logic is applicable only for data updated on two clusters at the same time (or within the replication window which is the network latency between the sites).

- **How do you specify the local site cluster lookup service for the Gateway?**
The Gateway will use both the local site lookup service and also its own lookup service to allow gateways deployed in different locations to find it.
The info about the local lookup service comes from the GSC hosting the Gateway where its `LOOKUPGROUP/LOOKUPLOCATORS` variable value injected into the deployed Gateway.

- **Should the schema of space classes across the sites be identical?**
Yes. If you have dynamic data model you should use the Space Document. This will allow you to have flexible data model.
