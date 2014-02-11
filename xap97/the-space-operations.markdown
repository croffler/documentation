---
layout: post
title:  Operations
categories: XAP97
parent: the-space.html
weight: 3000
---


{% summary %}Describes the main XAP API for interacting with the space{% endsummary %}

# Overview

XAP provides a simple space API using the [GigaSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html) interface for interacting with the space.


The interface includes the following main operations:

{: .table .table-bordered}
|[Id Based operations](./id-queries.html)|[Batch operations](#Batch Operations)|[Asynchronous operations](#Asynchronous Operations)|Data Count operations|
|:--|:--|:--|:--|
|[readById](./id-queries.html#Reading an Object using its ID){% wbr %}takeById{% wbr %}[readByIds](./id-queries.html#Reading Multiple Objects using their IDs){% wbr %}takeByIds{% wbr %}readIfExistsById{% wbr %}takeIfExistsById|readMultiple{% wbr %}takeMultiple{% wbr %}[writeMultiple](#writeMultiple){% wbr %}readByIds{% wbr %}takeByIds|asyncRead{% wbr %}asyncTake{% wbr %}asyncChange{% wbr %}execute|count|

{: .table .table-bordered}
|[Data Query operations](./sqlquery.html)|Data Insert and Update operations|[Business logic execution operations](./task-execution-over-the-space.html)|Data removal operations|
|:--|:--|:--|:--|
|read{% wbr %}readMultiple{% wbr %}[iterator](./paging-support-with-space-iterator.html)|write{% wbr %}writeMultiple{% wbr %}   [change](./change-api.html) |execute{% wbr %}executorBuilder|clean{% wbr %}clear{% wbr %}take{% wbr %}takeMultiple|


# Simpler API

The `GigaSpace` interface provides a simpler space API by utilizing Java 5 generics, and allowing sensible defaults. Here are some examples of the space operations as defined within `GigaSpace`:

{% highlight java %}
public interface GigaSpace {

    <T> LeaseContext<T> write(T entry) throws DataAccessException;
    // ....

    <T> T read(ISpaceQuery<T> query, Object id)throws DataAccessException;

    // ......
    <T> T take(T template) throws DataAccessException;

    <T> T take(T template, long timeout) throws DataAccessException;
}
{% endhighlight %}

In the example above, the take operation can be performed without specifying a timeout. The default take timeout is `0` (no wait), and can be overridden when configuring the `GigaSpace` factory. In a similar manner, the read timeout and write lease can be specified.




{%include xap97common/ops-write.markdown %}
{%include xap97common/ops-read.markdown %}
{%include xap97common/ops-take.markdown %}
{%include xap97common/ops-clear.markdown %}
{%include xap97common/ops-count.markdown %}





