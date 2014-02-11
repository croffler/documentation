---
layout: post
title:  Paging Support
categories: XAP97
parent: querying-the-space.html
weight: 700
---

{% summary %}Reading large number of objects using multiple queries in one call in a continuous manner. {% endsummary %}

# Overview

The [IteratorBuilder](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/IteratorBuilder.html) with the [GSIterator](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/j_spaces/core/client/GSIterator.html)  provides the ability to exhaustively read through all of the objects from the space that match one or more SQLQuery/templates.

There are scenarios where the conventional read operation that returns a single space object does not fit and there is a need to return a collection of entries from the space. Generally, an iterator should be used in cases where returning all the entries in one result with the `readMultiple` operation will consume too much memory on the client or introduce too much latency before the first space object could be processed.

![paging-iteratorBuilder.jpg](/attachment_files/paging-iteratorBuilder.jpg)

The iterator constructs a match set (a collection of space objects instances) that incrementally returns the necessary objects in chunks or pages. The `GSIterator` constructs a proxy object that can be used to access a match set created by a space. The `GSIterator` will initially contain some population of objects specified by the operation that created it. These objects can be retrieved by calling the `next` method. A successful call to `next` will remove the returned object from the match set. Match sets can end up in one of two terminal states: `exhausted` or `invalidated`.

Simple usage example for the `IteratorBuilder` with the `GSIterator`:

{% highlight java %}
GigaSpace gigaspace = new GigaSpaceConfigurer(new UrlSpaceConfigurer("jini://*/*/mySpace")).gigaSpace();

SQLQuery<MySpaceClass> query1 = new SQLQuery<MySpaceClass>(MySpaceClass.class,"fName like 'f%'");
SQLQuery<MySpaceClass> query2 = new SQLQuery<MySpaceClass>(MySpaceClass.class,"lName like 'l%'");

IteratorBuilder iteratorBuilder = new IteratorBuilder(gigaspace)
	.addTemplate(query1)
	.addTemplate(query2)
	.bufferSize(100) // Limit of the number of objects to store for each iteration.
	.iteratorScope(IteratorScope.CURRENT_AND_FUTURE) ;
// Indicates that this iterator will be first pre-filled with existing matching objects anf future matching objects,
// otherwise it will start iterating only on newly arriving objects to the space.

GSIterator gsIterator = iteratorBuilder.iterate();
int count = 0;

for (;;)
{
        try
        {
	    MySpaceClass o = (MySpaceClass)gsIterator.next(60000);
	    System.out.println((count ++ ) + " " + o);
            } catch (NoSuchElementException e) {
             // will be thrown if there is no matching object and 60000 ms gone by
            }
}
{% endhighlight %}

# The IteratorBuilder

The [IteratorBuilder](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/IteratorBuilder.html) is a utility builder class for the GSIterator. It allows to use method chaining for simple configuration of an iterator and then call iterate() to get the actual iterator.

By default, when no template is added (using `addTemplate`), a `null` template will be used to iterate over all the content of the Space.

The iterator can iterate on objects **currently** in the space, **future** entries or **both**. By default it will only iterate on **future** objects in the Space (objects that match the given template(s)). Use iteratorScope(IteratorScope) to set the iterator's scope.

Lease for the iterator can be controlled using `leaseDuration(long)`. A leased iterator which expires is considered as invalidated. A canceled iterator is an exhausted iterator and will have no more entities added to it. Calling next on an iterator with either state always returns `null` or it may throw one of the allowed exceptions. In particular `next(timeout)` may throw `NoSuchObjectException` to indicate that no object has been found during the allowed timeout. There is no guarantee that once `next(timeout)` throws a `NoSuchObjectException`, or next returns `null`, all future calls on that instance will do the same.

If there is a possibility that an iterator may become invalidated, it must be leased. If there is no possibility that the iterator will become invalidated, implementations should not lease it (i.e. use `Lease.FOREVER`). If there is no further interest an iterator may be canceled.

An active lease on an iterator serves as a hint to the space that the client is still interested in matching objects, and as a hint to the client that the iterator is still functioning. There are cases, however, where this **may not** be possible in particular, it is not expected that iteration will maintain across crashes. If the lease expires or is canceled, the iterator is invalidated. Clients should not assume that the resources associated with a leased GSIterator will be freed if the GSIterator reaches the exhausted state, and should instead cancel the lease.

The maximum number of objects to pull from the space can be controlled using `bufferSize(int)` and defaults to `100`.

# The IteratorScope

The [IteratorScope](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/iterator/IteratorScope.html) determines the scope of a GSIterator. Here are the supported options:

- `CURRENT` - Indicates that the iterator will process entries currently in the space, and ignores future changes.
- `CURRENT_AND_FUTURE` - Indicates that the iterator will process both entries currently in the space and future changes.
- `FUTURE` - Indicates that the iterator will ignore entries currently in the space, and process future changes.

# The GSIterator

The [GSIterator](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/j_spaces/core/client/GSIterator.html) will initially contain some population of objects. These objects can be retrieved by calling `next` method. A successful call to `next` method will remove the returned object from the iteration result set. An iterator can end up in one of two terminal states, `invalidated` or `exhausted`.

A leased iterator which expires is considered as invalidated. A canceled iterator is an exhausted iterator and will have no more entities added to it. Calling next on an iterator with either state always returns null or it may throw one of the allowed exceptions. In particular next(timeout) may throw NoSuchObjectException to indicate that no object has been found during the allowed timeout. There is no guarantee that once next(timeout) throws a NoSuchObjectException, or next returns null, all future calls on that instance will do the same.

Between the time an iterator is created and the time it reaches a terminal state, objects may be added by the space. However, an object that is removed by a next call may be added back to the iterator if its uniqueness is equivalent. The space may also update or remove objects that haven't yet been returned by a `next` call, and are not part of the buffered set.

{% comment %}

A match set becomes exhausted or invalidated specified by the operation that created it under the following conditions:

- An exhausted match set is empty and will have no more entries added. Calling next on an exhausted match set must always return `null`.
- Calling next on an invalidated match set may return a `non-null` value, or it may return a `NoSuchObjectException` to indicate that the match set has been invalidated. Once next throws a `NoSuchObjectException`, all future next calls on that instance will throw `NoSuchObjectException`.
- Calling next on an invalidated match set does not return `null`.
- Entries are not added to an invalidated match set.

Between the time a match set is created and the time it reaches a terminal state, entries may be added by the space. However, a space object that is removed by a `next` call must not be added back to a match set (though if there is a distinct but equivalent object in the space it may be added). The space may also remove Entries independent of next calls. The conditions under which Entries will be removed independent of next calls or added after the initial creation of the match set are specified by the operation that created the match set.

An active lease on a match set serves as a hint to the space that the client is still interested in the match set, and as a hint to the client that the match set is still functioning, i.e., if a match set is leased and the lease is active, `GSIterator` will maintain the match set and will not invalidate it.

If the iterator lease expires or is canceled, `GSIterator` will invalidate the match set. Clients should not assume that the resources associated with a leased match set will be freed automatically if the match set reaches the exhausted state, but should explicitly cancel the lease.

The `GSIterator` constructed using the following parameters:

- Collection of SQLQuery or templates.
- Including or excluding existing matched Entries in the space.
- Limit.
- Lease, Renew Lease, Cancel Lease.
- Next (returns Entry).
- Blocking Next (next with timeout).
{% endcomment %}

## Using GSIterator with SQLQuery

When using the `GSIterator` with [SQLQuery](./sqlquery.html), only [simple SQL queries](./sqlquery.html#Simple Queries - Supported and Non-Supported Operators) are supported:
    (field1 < value1) AND (field2 > value2) AND (field3 == values3)...
The following operators **are not supported** when using `GSIterator`:

- `NOT LIKE`
- `OR`
- `IN`
- `GROUP BY`
- `ORDER BY`

{% comment %}
# API - Constructor Summary

{% highlight java %}
GSIterator(com.j_spaces.core.IJSpace space, java.util.Collection collectionTemplates)
GSIterator with default Iterator Buffer size (100 entries), without History property,
and Lease.FOREVER as the iterator lease.
GSIterator(com.j_spaces.core.IJSpace space, java.util.Collection collectionTemplates,
int bufferSize, boolean withHistory, long lease)
GSIterator Constructor
{% endhighlight %}

{: .table .table-bordered}
| Return Value | Method |
|:-------------|:-------|
| `void` | `cancel()` {% wbr %}Used by the lease holder to indicate that it is no longer interested in the iterator. |
| `long` | `getExpiration()`{% wbr %}Returns the absolute time that the lease will expire, represented as milliseconds from the beginning of the epoch, relative to the local clock. |
| `boolean` | `hasNext()`{% wbr %}Returns `true` if the iterator has more elements. |
| `net.jini.core.entry.Entry` | `next()`{% wbr %}Returns the next matching-template Entry in the iterator. |
| `net.jini.core.entry.Entry` | `next(long timeout)`{% wbr %}Blocking next with timeout -- returns the next matching-template Entry in the iterator, under the timeout limitation. |
| `void` | `notify(net.jini.core.event.RemoteEvent event)`{% wbr %}For internal use. |
| `void` | `renew`(long duration) {% wbr %}Used to renew a lease for an additional period of time, specified in milliseconds. |
| `net.jini.core.entry.Entry` | `snapshot()`{% wbr %} Returns a snapshot of the Entry returned by the last next call, as defined in section JS.2.6 of the [JavaSpaces specification](http://www.sun.com/software/jini/specs/js2_0.pdf#search=%22javaspaces%20specification%22). |
{% endcomment %}

## Initialization

When a `GSIterator` is created, a match set is formulated. The match set initially contains all of the objects witin the space that match one or more of the collection templates and are not locked by conflicting transactions (unless using the `FUTURE` IteratorScope mode, i.e., no initial contents). Each element of the matched set will be returned at most once.

## hasNext(), next() and next(timeout)

Calling `hasNext()` returns `true` if next returns a non-null element rather than throwing an exception. Calling next removes one element from the matched set and returns it to the caller. Calling `next(timeout)` blocks next. The iteration is said to be complete if the match set becomes empty or next calls limit (buffer size) has removed Entries from the match set. A `next` call returns `null` only if the iteration is complete.

## take() and Space Object Lease Expiration

A space object may be, but is not required to be, removed from the match set without being returned by a `next` call if it is removed from the space or is locked by a conflicting transaction. `GSIterator` **does not remove** the object after it has been buffered.

## Notifications

GSIterator register each of the templates in the templates collection for notification. If a matching object was written to the space after the GSIterator was created, the object will be added to the result set. An object that was locked under a conflicting transaction before or after the GSIterator was created and the lock was released before the iteration was complete will also be added to the result set.

A matching that arrived from a notification event will interrupt any blocking `next(timeout)` operation. If a take operation was called or an object lease timeout, the object will be removed from the next iteration result set.

## Iterator Lease

In most cases, the iterator will be leased and the lease proxy object can be obtained by calling the `getLease()` method. Cancelling or letting the lease expire will destroy the iterator; thus no notifications from here on will be accounted for, and all subsequent calls to `hasNext()` will return `false`. If there is a lease associated with the iterator, clients should not assume that completing the iteration will destroy it and should instead call cancel or let the lease expire when the end of the iteration is reached. A lease `renewal(timeout)` is used to renew a lease for an additional period of time. This duration is not added to the original lease, but is used to determine a new expiration time for the existing lease. If a lease has expired or has been canceled, a renewal is not allowed.

## Transactions

Iterating through the matched set does not lock the object. Objects that are under transaction and match the specified template/SQLQuery will not be included as part of the matched set.

{% comment %}
## snapshot

The snapshot method returns a snapshot of the Entry returned by the last next call (see section JS.2.6 of the [JavaSpaces specification](http://www.sun.com/software/jini/specs/js2_0.pdf#search=%22javaspaces%20specification%22)). If the last next call returned `null` or failed with an exception or error, the snapshot will throw an `IllegalStateException.` It is important to note that the `GSIterator.snapshot()`, unlike the `JavaSpace.snapshot()`, does not throw a `RemoteException`.

{% tip %}
The `GSIterator` uses the following `NotifyModifiers`:

- `NotifyModifiers.NOTIFY_WRITE` -- updates the Iterator with a new Entry.
- `NotifyModifiers.NOTIFY_TAKE and NotifyModifiers.NOTIFY_LEASE_EXPIRATION` -- removes an Entry from the Iterator.

Updates do affect the iterator.
{% endtip %}
{% endcomment %}


<ul class="pager">
  <li class="previous"><a href="./query-user-defined-classes.html">&larr; User Defined Class</a></li>
  <li class="next"><a href="./getting-partial-results-using-projection-api.html">Partial Results &rarr;</a></li>
</ul>