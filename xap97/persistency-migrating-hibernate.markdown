---
layout: post
title:  Migrating from Hibernate
categories: XAP97
parent: space-persistency.html
weight: 900
---

{% summary %}GigaSpaces's persistency approach consists of several paradigms for data persistency, according to the application needs. This section gives a basic overview of each paradigm. {% endsummary %}



# Migrating Legacy Hibernate API Applications to GigaSpaces API

To benefit from data caching and other capabilities, it is worthwhile to migrate a legacy application that uses the Hibernate API, to the GigaSpace or GigaMap API. In such cases, these applications can benefit from the ability to scale when using the GigaSpaces Data Grid. This is achieved by partitioning the data across different spaces running on different machines, and having the business logic colocated with each partition. This allows the space and the business logic to run in same memory address, eliminating remote calls when accessing the data.

The following tables show the correspondence between the Hibernate basic API methods to [GigaSpaces API](./the-gigaspace-interface.html) and the [GigaMap API](./map-api.html) methods.

{: .table .table-bordered}
| `org.hibernate.Session Method` | `GigaSpace` Method| `GigaMap` Method|
|:-------------------------------|:------------------|:----------------|
| `save` |write|put |
| `persist` |write|put |
| `delete` | clear |remove |
| `update` |write|put |
| `merge` |write|put |
| `saveOrUpdate` |write|put |
| `replicate` |write|put |
| `get` |read, readByID|get |
| `load` |read, readByID|get |
| `createSQLQuery` | readByIDs, readMultiple(SQLQuery) , |Not supported|

The [Moving from Hibernate to Space](/sbp/moving-from-hibernate-to-space.html) best practice includes step by step instructions for moving from Hibernate based application to GigaSpaces Data-Grid as the data access layer. This use Hibernate as the space persistency layer using write-through approach when pushing updates into the database.

{% tip %}
The space can be used as a [Hibernate second level cache](./gigaspaces-for-hibernate-orm-users.html).
{% endtip %}

# Caching policies and Space Persistency

[Space Persistency](./space-persistency.html) supports the **All In Cache** and **LRU** [Cache policies](./memory-management-facilities.html).

## All In Cache Policy

With the [All In Cache policy](./all-in-cache-cache-policy.html), the assumption is the Space holds the entire data in memory. In this case, the space communicated with the data source at startup, and loads all the data. If data within the space is updated/added/removed, the space is calling the [`SpaceSynchronizationEndpoint`](./space-synchronization-endpoint-api.html) implementation to update the underlying data source. All data activities leveraging the data in memory.

{% comment %}
### Delegating Queries Directly to the Data Source

When using `readMultiple` with `Integer.MAX_VALUE` or very large value as the maximum amount of objects to be retrieved, having the space acting as a caching layer would not provide any performance or scalability boost. The application will always access the database (indirectly via the space) and load data into the space that will never be reused. With a partitioned space and a query/template that does not include a value for the routing field, all the partitions will access the database in parallel and will try to load relevant data that may generate an extra load on the database.

A better approach in such a case would be to delegate queries into the database directly based on the query type and the content of the data within the space. For example, if the data within the space in 3 days old, and the query looking for data that is few hours old, the query should be delegated to the space.

![query-service.jpg](/attachment_files/query-service.jpg)

You should have such delegation implemented at the application level or via a "Query Service" that will handle all the queries executed by the different applications. The "Query Service" can be accessed using [Task Executors](./task-execution-over-the-space.html) or [remoting](./executor-based-remoting.html). In such a case you should run the space in ALL_IN_CACHE policy and implement one of the [eviction patterns](/sbp/custom-eviction.html).
{% endcomment %}

## LRU Cache Policy - Read-Ahead

LRU persistency model is based on the eviction model: **Some** of the data stored In-Memory (based on auto expiration mechanism or explicit data eviction) and **ALL** the data stored on disk where the preferred disk media is a database. You may leverage Hibernate as the mapping layer when data is persist or have a custom persistency mapping implemented leveraging the [Space Data Source API](./space-data-source-api.html).

{% tip %}
GigaSpaces do not support the overflow model when persisting data since it may lead to inconsistency situations.
{% endtip %}

.
Using a database to store the data allows you to:

- Reload it very fast into the space with plenty of flexibility to customize the load activity.
- Allows the system to query the database when needed.

Database technology has proven itself to be able to store vast amount of data very efficiently with very good high-availability. You may use [RDBMS](http://en.wikipedia.org/wiki/RDBMS) SQL databases (mySQL, Oracle, Sybase, DB2) or [NoSQL](http://en.wikipedia.org/wiki/NoSQL) databases (MongoDB , MarkLogic, AllegroGraph) as the space persistency layer.

{% tip %}
When using NoSQL databases you may also leverage GigaSpaces [Document API](./document-api.html) support to map complex data structure into a document data store model.
{% endtip %}

With the [LRU policy](./lru-cache-policy.html), the assumption is that some of the data (recently used) is stored in memory. The amount of data stored in memory is limited by the **cache size** parameter, the memory usage watermark threshold parameters and available free GSC JVM heap size. In this case, once the space is started is loads data up 50% (you may tune this value) of the defined cache max size (total of objects per partition).

If data within the space is updated/added/removed, the space is calling the [`SpaceSynchronizationEndpoint`](./space-synchronization-endpoint-api.html) implementation to update the underlying data source. When performing read operations for a single object (read/readById/readIfExists) and no matching object is found in-memory (cache miss), the [`SpaceDataSource`](./space-data-source-api.html) implementation is called to search for a matching data to be loaded back into the space and from there sent to the client application (read-ahead). If a query is executed (readMultiple), and the max objects to read exceed beyond the amount of matching objects in memory, the `SpaceDataSource` is called to search for matching data elements to be loaded back into the space and from there sent to the client application. In this case, the client might have in return objects that were originally within the space, and objects that have been read from the data source and loaded into the space as a result of the query operation.

{% tip %}
The [IMDG with Large Backend Database Support](/sbp/imdg-with-large-backend-database-support.html) best practice suggest a simple approach you may use to leverage LRU Space with a large database allowing the application to **execute queries** against the space in an optimal manner.
{% endtip %}

In both cases (ALL_IN_CACHE and LRU cache policy), you can [customize the data load phase](./space-persistency-initial-load.html) to speed up the space initialization phase.

# Space Persistency

The space can load data from data sources, store data into data sources, and persist data into a relational data source or any other media via a custom [`SpaceSynchronizationEndpoint`](./space-synchronization-endpoint-api.html) implementation. [Space Persistency](./space-persistency.html) a built-in implementation using [Hibernate](./hibernate-space-persistency.html), to store data in an existing data source and in the space. Data is loaded from the data source during space initialization (via the `SpaceDataSource` implementation), and from then onwards the application works with the space directly. Meanwhile, the data source is constantly updated with all the changes made in the space (via the `SpaceSynchronizationEndpoint` implementation). This is the recommended model.

The [Hibernate Space Persistency](./hibernate-space-persistency.html) support RDBMS. The [Cassandra Space Persistency](./cassandra-space-persistency.html) allows applications to leverage NoSQL Cassandra DB having a distributed database infrastructure as an alternative to RDBMS.

{% children %}
