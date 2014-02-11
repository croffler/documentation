---
layout: post
title:  GigaSpaces Performance
categories: XAP97
parent: tuning-gigaspaces-performance.html
weight: 100
---

{% summary %}Helpful recommendations for tuning GigaSpaces, boosting its performance, and improving its scalability.{% endsummary %}

# Overview

This section lists helpful recommendations for tuning your application when using GigaSpaces XAP to boost its performance, and improving its scalability.

# Better Data Model

Consider embedded relationship model when possible instead of having separate space objects.

# Use readById

This will will avoid query the data. Will provide access directly to the data without any broadcast calls to the entire cluster.

# Use Paging

Use the **IteratorBuilder** when accessing large amount of objects.

# Use Delta Update

Consider the **GigaSpace.Change** operation when updating space objects.

# Design Your Space Class

Pay attention to the size of your space class -- do you really need all this information in the space? The bigger your space objects, the longer it takes to move them around, store them to disk, and fetch them back. Consider replacing a heavyweight blob field with a simple string URL, and use it later for fetching on demand. Contact GigaSpaces support for an example of this pattern. If you are using user-defined classes for your Space Class fields, try efficiently implementing **java.io.Externalizable** with these classes. This will reduce the amount of data transferred over the network, saving both time and memory space. Use binary Serialization with large collections.

# Make proper use of Indexes

GigaSpaces XAP includes a sophisticated built-in real-time indexing engine (regardless whether the space is persistent or not) that maintains a hash and btree like indexes for each indexed Space Class attribute. If you store a large number of Space objects from the same class type in the space, consider defining one or more indexes for attributes used with [template matching](./template-matching.html) or [SQL Query](./sqlquery.html). Defining indexes will improve the `read/take/readMultiple/takeMultiple/clear/count` operations response time significantly. Remember, indexes impact `write` and `take` operations response time, so choose your indexed fields carefully - each index has an overhead. GigaSpaces support index for equality , comparison (bigger/less than) queries and support [Regular Index](./indexing.html) for a specific field and a [Compound Index](./indexing.html#Compound Indexing) for multiple fields. Indexes can be defined for space class root level object or for a nested field allowing you to query different type of objects ("join") using the same query without any performance penalty. For bigger/less than/between queries use the **Extended index**.

# Use Asynchronous Operation

Consider using **GigaSpace.asyncChange** , ONE WAY write modifier , etc when available.

# Use Delta Read

Consider using query projections to retrieve only the specific portions needed when reading space objects.

# Colocate Data and Business Logic

Implement Task / Distributed Task to be used with the **GigaSpace.execute** operation or use colocated notify/polling container to move processing business logic to the data side. This will avoid serialization and network usage.

# Intelligent Partitioning

Partition data based on the business logic and not based on some unique value. This will allow the collocated logic to access its data without any network calls. If needed , run a local cache/local view to store "reference data" within each PU instance together with the transnational data.

# Blocking Take and Thread Consumption

When performing blocking operations -- read or take with timeout >0, it is recommended to set the operation timeout for short duration (5-30 seconds), and not to `FOREVER`.  This allows the space's internal thread pool to balance the different requests without exhausting all pending operations thread pool.

# Use Batch Operations

Batch operations (`writeMultiple, readMultiple, clear, updateMultiple`) perform actions on groups of space objects in one call. Instead of paying a penalty for every space object (remote call, database access, ...) you pay it only once. Try to design your hot spots around batch operations - this can drastically improve your application performance, up to ten to fifty times faster.

# Use Transactions Cautiously

Each transaction has an overhead. Do not use read under a transaction if you do not have a very good reason to do so. Use non-transactional read instead. This reduces database access for persistent spaces and eliminates transaction locks. If you really need to do some operations inside a transaction, use batch operations with transactions.

# Query Optimizations

When using the or logical operation together with and operations as part of your query (JDBC , JavaSpaces with SQLQuery) you can speed up the query execution by having the and conditions added to each or condition.
For example:

{% highlight java %}
select uid,* from table where (A = 'X' or A = 'Y') and (B > '2000-10-1' and B < '2003-11-1')
{% endhighlight %}

would be executed much faster when changing it to be:

{% highlight java %}
select uid,* from table where (A = 'X' and B > '2000-10-1' and B < '2003-11-1')
or (A = 'Y' and B > '2000-10-1' and B < '2003-11-1')
{% endhighlight %}

# Use an Embedded Space if Possible

If you access the space from a single JVM, or access it a large number of times from one JVM, use the embedded space mode. This eliminates the overhead of remote calls to the space. The slower your network compared to other resources (for example, a disk), the greater will be the noticeable improvement.

# Distribute Data and User Requests among Several Partitions

A single machine is always limited in the amount of data and user requests it can handle.
You can use [Data-Partitioning](./data-partitioning.html) to distribute the data and the calculation colocated with each partition. In more advanced scenarios you should use the [Master-Worker pattern](/sbp/master-worker-pattern.html) to distribute the data and the calculation in a different ratio.

# Memory Usage Considerations

**Here are several guidelines to reduce the client and space server memory footprint:**

- In order to reduce memory consumption, you can store multiple `long/integer` space object attribute values as part of a `long/integer array`. If you have lots of space objects this will improve the server footprint.
- Use indexes only for attributes used for matching. Make sure your space uses the `-1` value for the space implicit indexing property. This will ensure that indexes will be created upon request only.
- Make sure the statistics filter is turned off.
- Make sure all space workers are turned off.
- If you do not need `Lease` objects use the `NOWriteLease=true` as part of the URL. That's the default starting with XAP 9.
- Encapsulates all non-indexed field into an inner custom class and have all `primitive class` (Integer,Long,..) fields as part of the inner class with primitive types (int, long).
- Replace string space object fields with a custom implementation, which only supports basic ascii subset (backed with byte).
- Replaced string fields with a small number of possible (source for instance) values with enum.
- Indexes footprint can be reduced by directing the system to work in Economy mode. The downside of working in Economy mode is a performance penalty of up to 15% in embedded space operations. In order to work in Economy mode set `space-config.engine.use_economy_hashmap=true`.

{%comment%}

# Choose Local Transactions Over Distributed Transactions

[Distributed Transactions](./transaction-management.html#Distributed Jini Transaction Manager) perform a lengthy 2PC process. [Local Transactions](./transaction-management.html#Local Jini Transaction Manager), in contrast, perform a 1PC process. If you are performing some operations under a transaction on a single space, use local transactions. The slower your network compared to other resources (for example, a disk), the greater will be the noticeable improvement.


{% tip %}
For more details on transaction support, refer to the [Transaction Management](./transaction-management.html) section.
{% endtip %}

{%endcomment%}

# Using Snapshot to Reduce Object Creation and Space Object Data Inspection

When using the same template for matching, consider using a snapshot template. A snapshot template is the result object of the `GigaSpace.snapshot` call. The returned result includes GigaSpaces internal representation of the template object that does not need to undergo any inspection before it is sent to the GigaSpaces server.

{% tip %}
The snapshot returns an object you can use for subsequent matching as a template.
{% endtip %}

# Determine Cache Size

When using persistent space and reusing data, you must take caching into account. The cache manager caches space objects for use and performs an LRU (Least Recent Use) based cleanup on the cache. When searching for a space object , the cache is searched first. Set the cache size to the number of Space objects that your environment can reasonably contain as resident in the VM heap size. This will prevent unnecessary queries on your database. If you want the cache size to be based on the JVM running the space you may use the memory usage options.

# Determine Database Connection Pools

When using persistent space and a large number of users/threads access the space concurrently, each of them requires a database connection. Set enough connections in the connection pool so that users won't be blocked. You should calculate the number of concurrent requests the space needs to handle based on the number of users that will access the space simultaneously.

# Benchmarking Your Tuning

The Benchmark View provides a user interface for benchmarking the space.

{% tip %}
For more details, refer to:

- [Benchmark View](./benchmark-view---gigaspaces-browser.html)
- [Benchmark Example](./benchmark-utility---gigaspaces-cli.html)
{% endtip %}

