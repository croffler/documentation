---
layout: post
title:  Split-Brain and Active Election - General Definition
categories: XAP97
parent: split-brain-and-island-scenarios.html
weight: 100
---

{% summary %}How a network of processors elects a unique processor (a leader), and how to avoid split-brain scenarios.{% endsummary %}

# General Definition of Split-Brain

Very often, a network of processors has to solve a problem for which coordination is needed. There should be a unique processor (leader), known by all the others. The unique processor typically knows the other processors running across the network and coordinates their work by assigning them their relevant roles. In any case, the leader should distribute to the processors under its coordination some information defining the status of each processor.

The problem is making all of the processors in the network agree on one that will act as a leader. If the network is disconnected, each connected processor should elect its own leader. This problem might be more severe in WAN-based environments that are more exposed to network disconnections.

The cause could be the presence of failures in a distributed, decoupled environment.

The strategy to solve the problem is to give a priority number to all processors, and electing the non-failed processor with the highest priority as the leader. Under the failure assumption, after a certain amount of time, the network can be split into more than one connected processors. Each connected subset of processors should then agree on a (different) leader.

From time to time, each processor checks the existence of its leader. If the leader is not detected, the processor enters a phase that triggers a new leader election.

On the other hand, some faulty processors can become alive again, thus constructing bridges that connect some portions of the network. A new leader should then be elected.

## Flow

1. Initially, each node is its own leader. Each leader periodically initiates a check to see whether there are other leaders on the network. If so, it tries to merge the groups of processes coordinated to be part of its own group. In order to eliminate the possibility of a livelock, the leaders wait a certain amount of time, inversely proportional to their priority, before starting the attempt of merging other groups. When this happens they invite the other neighbor leaders detected to join their group.
1. The groups have assigned a unique identification number, known by all member processes.
1. The leader of the group distributes its identity to all other processes.
1. If, after a certain amount of time, a node doesn't get any signals from the leader, it tries to detect whether the leader failed. In this case, the node cancels any previous relationship to its existing leader, and creates a new group that includes only itself as a leader.

## Space Active Election

The active election and split-brain scenarios might take place when constructing a clustered space using a cluster schema that includes the `<fail-over-policy>` policy:

- `primary-backup`
- `async-repl-sync2backup`
- `partitioned-sync2backup`

In this case, the space (process) is required to identify other existing primary spaces and ensure that only one primary (active) space exists.

### How it Works

The active election mechanism is based by default on the [Jini Lookup service](./about-jini.html), which serves as the distributed naming service to coordinate a three-phase join flow electing the active service. The current implementation is based on a generic naming service abstraction, that can be replaced with any other distributed directory service, such as LDAP.

Each service maintains its state using the naming service. Each service can have one of the following states:

- `PENDING` -- the service is trying to join the candidate list to be active.
- `PREPARED` -- the service is a candidate to be an active space.
- `ACTIVE` -- the service is active. All other services change their state to `PENDING`.

{% indent %}
![active_election_flow.jpg](/attachment_files/active_election_flow.jpg)
{% endindent %}

When a clustered space is started, only one active primary space should be elected per failover group. For example, when using the `partitioned-sync2backup` cluster schema, each partition can have several backup spaces (although it is recommended to have only 1 backup space per partition). The leader is elected from spaces that are part of the same load-balancing group that acts also as a fail-over group (a space that is part of partition X can't use the leader space that is part of partition Y).

When the active primary space fails, a new primary space is elected from the existing backup spaces. If an operation has routed to a backup space, this operation is transparently re-routed to the active primary space. If the operation is conducted using a transaction, a `net.jini.core.transaction.TransactionException` exception is thrown. In this case, the application should start a new transaction and repeat the transaction operation.

You can get the space primary/backup mode via the `com.gigaspaces.cluster.activeelection.core.ActiveElectionState` located at the Jini Lookup.

The `ActiveElectionState.getState()` method returns the following:

- `NONE` -- non-clustered space
- `PENDING` -- backup mode
- `ACTIVE` -- primary mode

The ServiceItem Editor window below displays the space proxy attributes list with the `ActiveElectionState` attribute for primary and backup space proxies:

{% indent %}
![IMG203.gif](/attachment_files/IMG203.gif)
{% endindent %}

`com.gigaspaces.cluster.activeelection.InactiveSpaceException` is thrown when a client tries to access a space using a non-clustered proxy (relevant when running in `failback=false` mode).

{: .table .table-bordered}
| Property (client side) | Description | Defualt value |
|:-----------------------|:------------|:--------------|
| com.gs.client.inactiveRetryLimit | Number of retires on operation,{% wbr %}waiting for one of the servers to become active after Active election. | 20 |
| com.gs.failover.standby-wait-time| Retry backoff sleep time(ms). Between retries{% wbr %}while waiting for one of the servers to become active after Active election. | 1000 ms|
