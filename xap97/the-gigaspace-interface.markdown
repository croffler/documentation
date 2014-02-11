---
layout: post
title:  The Space Interface
categories: XAP97
parent: programmers-guide.html
weight: 200
---


{% summary %}Describes the main XAP API for interacting with the space{% endsummary %}

# Overview

OpenSpaces provides a simpler space API using the [GigaSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html) interface, by wrapping the [IJSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/j_spaces/core/IJSpace.html) (and the Jini [JavaSpace](http://www.gigaspaces.com/docs/JiniApi/net/jini/space/JavaSpace.html)), and simplifying both the API and its programming model.

{% indent %}
![space_basic_operations91.jpg](/attachment_files/space_basic_operations91.jpg)
{% endindent %}

The interface allows a POJO or a Document domain model to be stored in the space, use declarative transactions, use Java 5 Generics, coherent runtime exception hierarchy, and more.

There are multiple runtime configurations you may use when interacting with the space:

# The giga-space Bean

The `os-core:giga-space` Spring Bean provides a simple way to confgire a GigaSpace object to be injected into the relevant Bean. It can have the following elements:

{: .table .table-bordered}
|Element|Description|Required|Default Value|
|:------|:----------|:-------|:------------|
|space| [The Space bean](./the-space-component.html). This can be an embedded space , remote space , local view or local cache proxy. |YES| |
|clustered|Boolean. [Cluster flag](./clustered-vs-non-clustered-proxies.html). Controlling if this GigaSpace will work with a clustered view of the space or directly with a cluster member. By default if this flag is not set it will be set automatically by this factory. It will be set to true if the space is an embedded one AND the space is not a local cache proxy. It will be set to false otherwise (i.e. the space is not an embedded space OR the space is a local cache proxy)| NO | true for remote proxy , false for embedded proxy|
|default-read-timeout|Numerical Value. Sets the default read timeout for `read(Object)` and `readIfExists(Object)` operations.|NO| 0 (NO\_WAIT). TimeUnit:millsec|
|default-take-timeout|Numerical Value. Sets the default take timeout for `take(Object)` and `takeIfExists(Object)` operations.|NO| 0 (NO\_WAIT). TimeUnit:millsec|
|default-write-lease| Numerical Value. Sets the default [space object lease](./leases---automatic-expiration.html) (TTL) for `write(Object)` operation. |NO| FOREVER. TimeUnit:millsec|
|default-isolation| Options: DEFAULT , READ\_UNCOMMITTED, READ\_COMMITTED , REPEATABLE\_READ|NO| DEFAULT|
|tx-manager|Set the transaction manager to enable transactional operations. Can be null if transactional support is not required or the default space is used as a transactional context. |NO| |
|write-modifier|Defines a single default write modifier for the space proxy. Options: NONE, WRITE\_ONLY, UPDATE\_ONLY, UPDATE\_OR\_WRITE, RETURN\_PREV\_ON\_UPDATE, ONE\_WAY, MEMORY\_ONLY\_SEARCH, PARTIAL\_UPDATE|NO| UPDATE\_OR\_WRITE |
|read-modifier|The modifier constant name as defined in ReadModifiers. Options:NONE, REPEATABLE\_READ, READ\_COMMITTED, DIRTY\_READ, EXCLUSIVE\_READ\_LOCK, IGNORE\_PARTIAL\_FAILURE, FIFO, FIFO\_GROUPING\_POLL, MEMORY\_ONLY\_SEARCH|NO|READ\_COMMITTED|
|take-modifier|Defines a single default take modifier for the space proxy. Options:NONE, EVICT\_ONLY, IGNORE\_PARTIAL\_FAILURE, FIFO, FIFO\_GROUPING\_POLL, MEMORY\_ONLY\_SEARCH|NO| NONE|
|change-modifier|Defines a single default change modifier for the space proxy. Options:NONE, ONE\_WAY, MEMORY\_ONLY\_SEARCH, RETURN\_DETAILED\_RESULTS|NO| NONE|
|clear-modifier|Defines a single default count modifier for the space proxy. Options:NONE, EVICT\_ONLY, MEMORY\_ONLY\_SEARCH|NO| NONE|
|count-modifier|Defines a single default count modifier for the space proxy. Options:NONE, REPEATABLE\_READ, READ\_COMMITTED, DIRTY\_READ, EXCLUSIVE\_READ\_LOCK, MEMORY\_ONLY\_SEARCH|NO| NONE|

Here is an example of the giga-space Bean:

{% inittab gigaspace|top %}
{% tabcontent Namespace %}

{% highlight xml %}
 <os-core:giga-space id="gigaSpaceClustered" space="space" clustered="true"
  	 default-read-timeout="10000"
  	 default-take-timeout="10000"
  	 default-write-lease="100000">
  	 <os-core:read-modifier value="FIFO"/>
  	 <os-core:change-modifier value="RETURN_DETAILED_RESULTS"/>
  	 <os-core:clear-modifier value="EVICT_ONLY"/>
  	 <os-core:count-modifier value="READ_COMMITTED"/>
  	 <os-core:take-modifier value="FIFO"/>

  	 <!-- to add more than one modifier, simply include all desired modifiers -->
  	 <os-core:write-modifier value="PARTIAL_UPDATE"/>
  	 <os-core:write-modifier value="UPDATE_ONLY"/>
  	</os-core:giga-space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}
<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
 	 <property name="space" ref="space" />
 	 <property name="clustered" value="true" />
 	 <property name="defaultReadTimeout" value="10000" />
 	 <property name="defaultTakeTimeout" value="100000" />
 	 <property name="defaultWriteLease" value="100000" />
 	 <property name="defaultWriteModifiers">
 	 <array>
 	 <bean id="updateOnly"
 	 class="org.openspaces.core.config.modifiers.WriteModifierFactoryBean">
 	 <property name="modifierName" value="UPDATE_ONLY" />
 	 </bean>
 	 <bean id="partialUpdate"
 	 class="org.openspaces.core.config.modifiers.WriteModifierFactoryBean">
 	 <property name="modifierName" value="PARTIAL_UPDATE" />
 	 </bean>
 	 </array>
 	 </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## GigaSpace with a Remote Space

A client comunicating with a remote space performs all its operation via a remote conenction. The remote space can be partitioned (with or without backups) or replicated (sync or async replication based).

{% indent %}
![remote-space.jpg](/attachment_files/remote-space.jpg)
{% endindent %}

Here is an example how a client application can create a `GigaSpace` interface interacting with a remote space:

{% inittab os_space_remote|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="jini://*/*/space" />
<os-core:giga-space id="gigaSpace" space="space"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="jini://*/*/space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

GigaSpace gigaSpace = new GigaSpaceConfigurer(new UrlSpaceConfigurer("jini://*/*/space")).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## GigaSpace with an Embedded Space

A client comunicating with a an embedded space performs all its operation via local conenction. There is no network overhead when using this approach.

{% indent %}
![embedded-space.jpg](/attachment_files/embedded-space.jpg)
{% endindent %}

To create a `GigaSpace` for a colocated (embedded) space the space URL should use embedded space URL format:

{% inittab os_space_emb|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />
<os-core:giga-space id="gigaSpace" space="space"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

GigaSpace gigaSpace = new GigaSpaceConfigurer(new UrlSpaceConfigurer("/./space")).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

The Embedded space can be used in a distributed architecture such as the replicated or partitioned clustered space:

{% indent %}
![replicated-space1.jpg](/attachment_files/replicated-space1.jpg)
{% endindent %}

A simple way to use the embedded space in a clustered architecture would be by deploying a [clustered space](./administrators-guide.html) or packaging your application as a [Processing Unit](./packaging-and-deployment.html) and deploy it using the relevant SLA.

## GigaSpace with a Local (Near) Cache

The `GigaSpace` support [Local Cache](./local-cache.html) (near cache) configuration. This provides a front-end client side cache that will be used with the `read` operations implictly. The local cache will be loaded on demand or when you perform a `read` operation and will be updated implictly by the space.

{% indent %}
![local_cache.jpg](/attachment_files/local_cache.jpg)
{% endindent %}

Here is an example for a `GigaSpace` construct with a local cache:

{% inittab os_local_cache|top %}
{% tabcontent Spring Namespace Configuration %}

{% highlight xml %}
<os-core:space id="space" url="jini://*/*/space" />
<os-core:local-cache id="localCacheSpace" space="space"/>
<os-core:giga-space id="localCache" space="localCacheSpace"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain Spring XML %}

{% highlight xml %}
<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="jini://*/*/space" />
</bean>

<bean id="localCacheSpace"
    class="org.openspaces.core.space.cache.LocalCacheSpaceFactoryBean">
    <property name="space" ref="space" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}
// Initialize remote space configurer:
UrlSpaceConfigurer urlConfigurer = new UrlSpaceConfigurer("jini://*/*/space");
// Initialize local cache configurer
LocalCacheSpaceConfigurer localCacheConfigurer =
    new LocalCacheSpaceConfigurer(urlConfigurer);
// Create local cache:
GigaSpace localCache = new GigaSpaceConfigurer(localCacheConfigurer).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## GigaSpace with a Local View

The `GigaSpace` support [Local View](./local-view.html) configuration. This provides a front-end client side cache that will be used with any `read` or `readMultiple` operations implictly. The local view will be loaded on start and will be updated implictly by the space.

{% indent %}
![local_view.jpg](/attachment_files/local_view.jpg)
{% endindent %}

Here is an example for a `GigaSpace` construct with a local cache:

{% inittab os_local_view|top %}
{% tabcontent Spring Namespace Configuration %}

{% highlight xml %}
<os-core:space id="space" url="jini://*/*/space" />

<os-core:local-view id="localViewSpace" space="space">
    <os-core:view-query class="com.example.Message1" where="processed = true"/>
    <os-core:view-query class="com.example.Message2" where="priority > 3"/>
</os-core:local-view>

<os-core:giga-space id="localView" space="localViewSpace"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain Spring XML %}

{% highlight xml %}
<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="jini://*/*/space" />
</bean>

<bean id="viewSpace" class="org.openspaces.core.space.cache.LocalViewSpaceFactoryBean">
    <property name="space" ref="space" />
    <property name="localViews">
        <list>
            <bean class="com.j_spaces.core.client.view.View">
                <constructor-arg index="0" value="com.example.Message1" />
                <constructor-arg index="1" value="processed = true" />
            </bean>
            <bean class="com.j_spaces.core.client.view.View">
                <constructor-arg index="0" value="com.example.Message2" />
                <constructor-arg index="1" value="priority > 3" />
            </bean>
        </list>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}
// Initialize remote space configurer:
UrlSpaceConfigurer urlConfigurer = new UrlSpaceConfigurer("jini://*/*/space");
// Initialize local view configurer
LocalViewSpaceConfigurer localViewConfigurer = new LocalViewSpaceConfigurer(urlConfigurer)
    .addViewQuery(new SQLQuery(com.example.Message1.class, "processed = true"))
    .addViewQuery(new SQLQuery(com.example.Message2.class, "priority > 3"));
// Create local view:
GigaSpace localView = new GigaSpaceConfigurer(localViewConfigurer).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# URL Examples

A pu.xml with a space bean accessing remote space (aka stateless PU):

{% highlight java %}
<os-core:space id="space" url="jini://*/*/space" />
<os-core:giga-space id="gigaSpace" space="space" tx-manager="transactionManager"/>
{% endhighlight %}

pu.xml with a space bean accessing remote space and embedded space (aka statefull PU):

{% highlight java %}
<os-core:space id="spaceRemote" url="jini://*/*/space" />
<os-core:giga-space id="gigaSpaceRemote" space=" spaceRemote"  tx-manager="transactionManager1"/>
<os-core:space id="spaceEmbed" url="/./space" />
<os-core:giga-space id="gigaSpaceEmbed" space="spaceEmbed"  tx-manager="transactionManager2"/>
{% endhighlight %}

A pu.xml with a space bean accessing remote space with a local view (stateless PU):

{% highlight java %}
<os-core:space id="spaceRemote" url="jini://*/*/space" />
<os-core:local-view id="localViewSpace" space="spaceRemote">
	<os-core:view-query class="com.example.Message1" where="processed = true"/>
</os-core:local-view>
<os-core:giga-space id="gigaSpaceLocalView" space="localViewSpace"/>
{% endhighlight %}

A pu.xml with a space bean accessing remote space with a local view , a regular remote space (without a view) and an embedded space (hybrid PU):

{% highlight java %}
<os-core:space id="spaceRemote" url="jini://*/*/space" />
	<os-core:local-view id="localViewSpace" space="spaceRemote">
	<os-core:view-query class="com.example.Message1" where="processed = true"/>
</os-core:local-view>

<os-core:giga-space id="gigaSpaceLocalView" space="localViewSpace"/>
<os-core:giga-space id="gigaSpaceRemote" space=" spaceRemote"  tx-manager="transactionManager1"/>

<os-core:space id="spaceEmbed" url="/./space" />
<os-core:giga-space id="gigaSpaceEmbed" space="spaceEmbed"  tx-manager="transactionManager2"/>
{% endhighlight %}

{% note %}
The application is always injected with `os-core:giga-space` bean that wraps always a `os-core:space`.
{% endnote %}

# Basic Usage Guidelines

Few basic usage guidelines when using the `GigaSpace` interface:

- The `GigaSpace` variable represents a remote or embedded space proxy (for a single space or clustered) and **should be constructed only** once throughout the lifetime of the application process.
- You should treat the `GigaSpace` variable as a singleton to be shared across multiple different threads within your application.
- The `GigaSpace` interface is a thread safe and there is no need to create a `GigaSpace` variable per application thread.
- In case the space has been fully terminated (no backup or primary instances running any more) the client space proxy will try to reconnect to the space up to a predefined timeout based on the [Proxy Connectivity](./proxy-connectivity.html) settings. If it fails to reconnect, an error will be displayed.
- The `IJSpace` interface is not hidden, and can be used even when using the `GigaSpace` interface. `GigaSpace` simplifies most operations used with the space (compared to `IJSpace`), but some operations still require access to `IJSpace`, which can be accessed through the `GigaSpace` API.
- The `GigaSpace` interface is a thin wrapper built on top of `IJSpace`. Within a single Processing Unit (or Spring application context), several `GigaSpace` instances can be defined, each with different characteristics, all will be interacting with the same rmeote space.

# Operations

The [GigaSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html) interface includes the following main operations:

{: .table .table-bordered}
|[Id Based operations](./id-queries.html)|[Batch operations](#Batch Operations)|[Asynchronous operations](#Asynchronous Operations)|Data Count operations|
|:--|:--|:--|:--|
|[readById](./id-queries.html#Reading an Object using its ID){% wbr %}takeById{% wbr %}[readByIds](./id-queries.html#Reading Multiple Objects using their IDs){% wbr %}takeByIds{% wbr %}readIfExistsById{% wbr %}takeIfExistsById|readMultiple{% wbr %}takeMultiple{% wbr %}writeMultiple{% wbr %}readByIds{% wbr %}takeByIds|asyncRead{% wbr %}asyncTake{% wbr %}asyncChange{% wbr %}execute|count|

{: .table .table-bordered}
|[Data Query operations](./sqlquery.html)|Data Insert and Update operations|[Business logic execution operations](./task-execution-over-the-space.html)|Data removal operations|
|:--|:--|:--|:--|
|read{% wbr %}readMultiple{% wbr %}[iterator](./paging-support-with-space-iterator.html)|write{% wbr %}writeMultiple{% wbr %}   [change](./change-api.html) |execute{% wbr %}executorBuilder|clean{% wbr %}clear{% wbr %}take{% wbr %}takeMultiple|

{% include xap97/pojo-code-snippets.markdown %}


{% tip %}
The `clear` and `clean` operations does not remove the space class definition from the space. You should restart the space to allow it to drop the class definitions.
{% endtip %}

# Clustered Flag

When configuring a [Space](./the-space-component.html) with an embedded clustered space or with a remote clustered space, a clustered `GigaSpace` proxy is created. A clustered proxy is a smart proxy that performs operations against the entire cluster when needed.

Many times, especially when working with a Processing Unit that starts an embedded space, operations against the space should be performed directly on the cluster member without interacting with the other space cluster members (partitions). This is a core concept of the SBA and the Processing Unit, where most if not all the operations should be performed in-memory without leaving the Processing Unit boundaries, when a Processing Unit starts an embedded space.

{% indent %}
![clustered-gigaspace.jpg](/attachment_files/clustered-gigaspace.jpg)
{% endindent %}

**Embedded Non-Clustered GigaSpace proxy vs. Embedded Clustered GigaSpace Proxy**

The decision of working directly with a cluster member or against the whole cluster is done in the `GigaSpace` level. The `GigaSpacesFactoryBean` provides a clustered flag with the following logic as the default value: If the space is started in embedded mode (for example, `/./space`), the clustered flag is set to `false`. When the space is looked up in a remote protocol (i.e. jini://*/*/space), the clustered flag is set to `true`. Naturally, the flag can be set explicitly. Here is an example of how the clustered flag can be configured:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />

<!-- By default, since we are starting in embedded mode, clustered=false -->
<os-core:giga-space id="directGigaSpace" space="space"/>

<os-core:giga-space id="clusteredGigaSpace" space="space" clustered="true"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>

<!-- By default, since we are starting in embedded mode, clustered=false -->
<bean id="directGigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
</bean>

<bean id="clusteredGigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
	<property name="clustered" value="true" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

IJSpace space = // get Space either by injection or code creation

GigaSpace gigaSpace = new GigaSpaceConfigurer(space).clustered(true).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

The above example shows a typical scenario where the clustered flag is used. Within a Processing Unit, an application might need to access both the cluster member and the whole cluster directly.

The [Clustered vs Non-Clustered Proxies](./clustered-vs-non-clustered-proxies.html) provide more details how to use Clustered Proxies.

# Simpler API

The `GigaSpace` interface provides a simpler space API by utilizing Java 5 generics, and allowing sensible defaults. Here is an example of the space take operation as defined within `GigaSpace`:

{% highlight java %}
public interface GigaSpace {

    // ....

    <T> T take(T template) throws DataAccessException;

    <T> T take(T template, long timeout) throws DataAccessException;
}
{% endhighlight %}

In the example above, the take operation can be performed without specifying a timeout. The default take timeout is `0` (no wait), and can be overridden when configuring the `GigaSpace` factory. In a similar manner, the read timeout and write lease can be specified.

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />

<os-core:giga-space id="gigaSpace" space="space" default-take-timeout="1000"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
    <property name="defaultTakeTimeout" value="1000" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

IJSpace space = // get Space either by injection or code creation

GigaSpace gigaSpace = new GigaSpaceConfigurer(space).defaultTakeTimeout(1000).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

{% tip %}
See more examples for the `GigaSpace` interface usage with the [POJO Support](./pojo-support.html) section.
{% endtip %}

# write Operation

A write operation places a copy of an object into the space. The object passed to the write is not affected by the operation. Each write operation places a new object into the space unless there is an object with the same `ID` already stored within the space. In such a case an **update operation** will be performed implictly. If you would like to change this default behavior you should change the update mode to use the `WriteModifiers.WRITE_ONLY` mode. When updating an object with many fields you may use the `PARTIAL_UPDATE` mode.

When performing a write operation you may provide a lease (time to live) duration (in milliseconds time unit) for the object. The write invocation returns a [Lease](./leases---automatic-expiration.html) object allowing you to cancel or renew the object lease. When the lease expires, the object is removed from the space. The default lease duration is `FOREVER`. An `IllegalArgumentException` will be thrown if the lease time requested is negative.

If a write returns without throwing an exception, that object is committed to the space, possibly within a transaction. If a `RemoteException` is thrown, the write may or may not have been successful. If any other exception is thrown, the object was not written into the space.

Writing an object into a space might generate [notifications](./notify-container.html) to registered objects.

## Time To Live - Lease

To write an object into the space with a limited time to live you should specify [a lease value](./leases---automatic-expiration.html) (in millisecond). The object will expire automatically from the space.

{% highlight java %}
gigaSpace.write(myObject, 10000)
{% endhighlight %}

You can [register for notifications](./notify-container.html) having a listener triggered when the object has been expired.

## Return Previous Value

When updating an object which already exists in the space, in some scenarios it is useful to get the previous value of the object (before the update). This previous value is returned in result `LeaseContext.getObject()` when using the `RETURN_PREV_ON_UPDATE` modifier.

![write_return_prev-value.jpg](/attachment_files/write_return_prev-value.jpg)

{% highlight java %}
LeaseContext<MyData> lc = space.write(myobject,WriteModifiers.RETURN_PREV_ON_UPDATE.add(WriteModifiers.UPDATE_OR_WRITE));
MyData previousValue = lc.getObject();
{% endhighlight %}

{% infosign %} Since in most scenarios the previous value is irrelevant, the default behavior is not to return it (i.e. `LeaseContext.getObject()` return null). The `RETURN_PREV_ON_UPDATE` modifier is used to indicate the previous value should be returned.

# Delta Update

You may update selected space object fields (delta) using the [WriteModifiers.PARTIAL_UPDATE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html) modifier. This option is useful when having objects with large number of fields where you would like to update only few of the space object fields. This optimizes the network utilization and avoids serializing/de-serializing the entire object fields when interacting with a remote space.

## How to Perform Delta Updates?

When using this modifier, fields that you do not want be update **should have the value `null`**. This means that only fields which are set will be sent from the client into the space to replace the existing field's value. In case of a backup (replica) space, the primary space will replicate only the updated fields (delta) to the replica space. Make sure the updated object include its ID when using this option.

{% exclamation %} To use Delta updates you don't have to implement any special interface or have special serialization code. You can use regular POJO as usual.

When updating an object, you can specify 0 (ZERO) as the lease time. This will instruct the space to use the original lease time used when the object has been written into the space.

`PARTIAL_UPDATE` Example:

{% highlight java %}
GigaSpace space = new GigaSpaceConfigurer (new UrlSpaceConfigurer("jini://*/*/space").noWriteLease(true)).gigaSpace();

// initial insert
MyClass obj = new MyClass();
obj.setId("1");
obj.setField1("A");
obj.setField2("B");
obj.setField3("C");
space.write(obj);

// reading object back from the space
MyClass obj2 = space.readById(MyClass.class , "1");

// updating only field2
obj2.setField1(null);
obj2.setField2("BBBB");
obj2.setField3(null);
try
{
	space.write(obj2,0,0,WriteModifiers.PARTIAL_UPDATE);
}
catch (EntryNotInSpaceException enise)
{
	// Object not in space - unsuccessful update
}
{% endhighlight %}

Alternatively, you can use the [change](./change-api.html) operation and update specific fields or even nested fields or modify collections and maps without having to supply the entire collection or map upon such update. The following `change` operation example is equivalent to the previous partial update operation.

{% highlight java %}
IdQuery<MyClass> idQuery = new IdQuery<MyClass>(MyClass.class, "1")
ChangeResult<MyClass> changeResult = space.change(idQuery, new ChangeSet().set("field2", "BBBB"));
if (changeResult.getNumberOfChangedEntries() == 0)
{
  // Object not in space - no change applied
}
{% endhighlight %}

# Data Access

There are various mechanisms offered by GigaSpaces XAP to access the data within the space:

## ID Based

Each space object includes an ID. You may read or remove objects from the space using their ID via the `readByID`,`takeByID`,`readIfExistsById`,`takeIfExistsById`, `readByIDs` or the `takeByIDs` operations.

{% tip %}
The `readByID` and `readByIDs` have a special performance optimization when running a [Local Cache](./local-cache.html) or [Local View](./local-view.html).
{% endtip %}

 See the [Id Queries](./id-queries.html) for details.

## Template Based

The template is a POJO of the desired entry type, and the properties which are set on the template (i.e. not null) are matched against the respective properties of entries of the same type in the space. Properties with null values are ignored (not matched). See the [Template Matching](./template-matching.html) for details.

## SQL Based

The [SQLQuery](./sqlquery.html) class is used to query the space using SQL-like syntax. The query statement includes only the `WHERE` statement part - the selection aspect of a SQL statement is embedded in other parameters for a SQL query. See the [SQLQuery](./sqlquery.html) for details.

## Space Iterator

The [IteratorBuilder](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/IteratorBuilder.html) with the [GSIterator](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/j_spaces/core/client/GSIterator.html) allows you to iterate over large amount of space objects in a **paging approach**. It avoids the need to retrieve the entire result set in one batch as the `readMultiple` since it is fetching the result set in batches. This optimizes the resource utilization (memory and CPU) involved when executing the query both at the client and server side. See the [Paging Support with Space Iterator](./paging-support-with-space-iterator.html) for details.

# readIfExists and read Operations

The two forms of the `read` operations query the space for an object that matches the template/[SQLQuery](./sqlquery.html) provided. If a match is found, a copy of the matching object is returned. If no match is found, `null` is returned. Passing a `null` reference as the template will match any object.

Any matching object can be returned. Successive read requests with the same template may or may not return equivalent objects, even if no intervening modifications have been made to the space. Each invocation of `read` may return a new object even if the same object is matched in the space. If you would like to read objects in the same order they have been written into the space you should perform the read objects in a [FIFO mode](./fifo-support.html).

A `readIfExists` operation will return a matching object, or a `null` if there is currently no matching object in the space. If the only possible matches for the template have **conflicting locks** from one or more other transactions, the `timeout` value specifies how long the client is willing to wait for interfering transactions to settle before returning a value. If at the end of that time no value can be returned that would not interfere with transactional state, `null` is returned. Note that, due to the remote nature of the space, `read` and `readIfExists` may throw a `RemoteException` if the network or server fails prior to the `timeout` expiration.

A `read` operation acts like a `readIfExists` except that it will wait until a matching object is found or until transactions settle, whichever is longer, up to the timeout period.

In both read methods, a timeout of `JavaSpace.NO_WAIT` means to return immediately, with no waiting, which is equivalent to using a zero timeout. An `IllegalArgumentException` will be thrown if a negative timeout value is used.

{% tip %}
The `read` operation default timeout is `JavaSpace.NO_WAIT`.
{% endtip %}

# takeIfExists and take Operations

The `take` operations perform exactly like the corresponding `read` operations, except that the matching object is **removed* from the space on one atomic operation. Two `take` operations will *never return** copies of the same object, although if two equivalent objects were in the space the two `take` operations could return equivalent objects.

If a `take` returns a non-null value, the object has been removed from the space, possibly within a transaction. This modifies the claims to once-only retrieval: A take is considered to be successful only if all enclosing transactions commit successfully. If a `RemoteException` is thrown, the take may or may not have been successful. If an `UnusableEntryException` is thrown, the take `removed` the unusable object from the space. If any other exception is thrown, the take did not occur, and no object was removed from the space.

With a `RemoteException`, an object can be removed from a space and yet never returned to the client that performed the take, thus losing the object in between. In circumstances in which this is unacceptable, the take can be wrapped inside a transaction that is committed by the client when it has the requested object in hand.

If you would like to take objects from the space in the same order they have been written into the space you should perform the take objects in a [FIFO mode](./fifo-support.html).

Taking an object from the space might generate [notifications](./notify-container.html) to registered objects/queries.

{% tip %}
The `take` operation default timeout is `JavaSpace.NO_WAIT`.
{% endtip %}

# Timeout Based Operations with LRU Cache Policy

When performing timeout based operations such as `read` , `take` or `write` where the space running in `LRU` cache policy mode using a persistent storage (RDBMS , NoSQL DB) the space can't guaranty the exact timeout specified as it can't control the persistent storage response time (to find a matching object or return with no matching object). When the requirement is to return immediately once there is no matching object within the space or the persistent storage , it is recommended not to use timeout based operation - i.e. have the timeout as ZERO.

# Batch Operations

The GigaSpace interface provides simple way to perform bulk operations. You may read or write large amount of objects in one call. The batch operations can be called using the following:

- GigaSpace.readMultiple - Bulk read.
- GigaSpace.takeMultiple - Bulk take (read+remove). Returns the removed objects back to the client.
- GigaSpace.writeMultiple - Bulk write and update.

{% exclamation %} To remove batch of objects without returning these back into the client use `GigaSpace.clear(SQLQuery)`;

Here are few important considerations when using the batch operations:

- The `readMultiple` and `takeMultiple` operations boost the performance, since they perform multiple operations using one call. These methods returns the matching results in one result object back to the client. This allows the client and server to utilize the network bandwidth in an efficient manner. In some cases, these batch operations can be up to 10 times faster than multiple single based operations.
- The `readMultiple` and `takeMultiple` operations should be handled with care, since they can return a large data set (potentially all the space data). This might cause an out of memory error in the space and client process. You should use the [GSIterator](#Space Iterator) to return the result in batches (paging) in such cases.
- Destructive batch operations (`takeMultiple` , `writeMultiple` , `updateMultiple`) should be performed with transactions - this allows the client to roll back the space to its initial state prior the operation was started, in case of a failure.
- When calling `writeMultiple` or `updateMultiple`, make sure `null` values are not part of the passed array.
- When using `writeMultiple`, you should verify that duplicated entries (with the same ID) do not appear as part of the passed array, since the identity of the object is determined based on its `ID` and not based on its reference. This is extremely important with an embedded space, since `writeMultiple` injects the ID value into the object after the write operation (when autogenerate=false).
- The `readMultiple` and `takeMultiple` operations **do not support timeout** operations. The simple way to achieve this is by calling the `read` operation first with the proper timeout, and if non-null values are returned, perform the batch operation.
- Exception handling - batch operations many throw the following Exceptions. Make sure you catch these and act appropriately:
    - [org.openspaces.core.WriteMultiplePartialFailureException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/WriteMultiplePartialFailureException.html)
    - [org.openspaces.core.WriteMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/WriteMultipleException.html)
    - [org.openspaces.core.ReadMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/ReadMultipleException.html)
    - [org.openspaces.core.TakeMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/TakeMultipleException.html)
    - [org.openspaces.core.ClearException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/ClearException.html)

# Asynchronous Operations

The GigaSpace interface supports asynchronous (non-blocking) read and asynchronous take operations through the GigaSpace interface. Both return a [Future\<T\>](http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Future.html) object, where T is the type of the object the request returns. Future<T>.get() can be used to query the object to see if a result has been returned or not.

Alternatively, asyncRead and asyncTake also accept an implementation of [AsyncFutureListener](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/async/AsyncFutureListener.html), which will have its `AsyncFutureListener.onResult` method called when the result has been populated. This does not affect the return type of the `Future<T>`, but provides an additional mechanism for handling the asynchronous response.

![async_operationsnew.jpg](/attachment_files/async_operationsnew.jpg)

Asynchronous `write` operation can be implemented using a [Task](./task-execution-over-the-space.html), where the `Task` implementation include a write operation. With this approach the `Task` is sent to the space and executed in an asynchronous manner. The write operation itself will be completed once both the primary and the backup will acknowledge the operation. This activity will be performed as a background activity from the client perspective.

{% inittab async_operations|top %}
{% tabcontent Space Class %}

{% highlight java %}

public class MyClass {
	String data;
	Integer id;
	public MyClass(){}
	public MyClass(int id , String data){
		this.id = id;
		this.data = data;
	}
	public MyClass(int id){this.id = id;}
	public String getData() {return data;}
	public void setData(String data) {this.data = data;}
	@SpaceId (autoGenerate = false)
	@SpaceRouting
	public Integer getId() {return id;}
	public void setId(Integer id) {this.id = id;}
}
{% endhighlight %}

{% endtabcontent %}
{% tabcontent AsyncFutureListener %}

{% highlight java %}

public class AsyncListener implements AsyncFutureListener<MyClass>{
	String operation;
	public AsyncListener(String operation)
	{
		this.operation=operation;
	}
	public void onResult(AsyncResult<MyClass> result) {
		System.out.println("Async " + operation+
			" Operation Listener - Found matching object:"+
				result.getResult());
	}
}
{% endhighlight %}

{% endtabcontent %}

{% tabcontent Async Read %}

{% highlight java %}

GigaSpace space = new GigaSpaceConfigurer (new UrlSpaceConfigurer("jini://*/*/space")).gigaSpace();
AsyncFuture<MyClass> futureRead =  space.asyncRead(new MyClass(1), 10000, new AsyncListener("Read"));
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Async Take %}

{% highlight java %}

GigaSpace space = new GigaSpaceConfigurer (new UrlSpaceConfigurer("jini://*/*/space")).gigaSpace();
AsyncFuture<MyClass> futureTake =  space.asyncTake(new MyClass(1), 10000, new AsyncListener("Take"));
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Async Write %}

{% highlight java %}

GigaSpace space = new GigaSpaceConfigurer (new UrlSpaceConfigurer("jini://*/*/space")).gigaSpace();
MyClass obj = new MyClass(1,"AAA");
space.write(obj,WriteModifiers.ONE_WAY);
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Declarative Transactions

As seen in the take API above, there is no need to provide a Jini transaction object for the different space operations. `GigaSpace` with the different OpenSpaces [transaction managers](./transaction-management.html) and Spring allow simple declarative definition of transactions. This boils down to the fact that if there is an ongoing transaction running, any operation performed using the `GigaSpace` interface joins it, using Spring's rich transaction support.

{% exclamation %} In order to have GigaSpace transactional, the transaction manager must be provided as a reference when constructing the GigaSpace bean. For example (using the distributed transaction manager):

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />

<os-core:distributed-tx-manager id="transactionManager"/>

<os-core:giga-space id="gigaSpace" space="space" tx-manager="transactionManager"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>

<bean id="transactionManager" class="org.openspaces.core.transaction.manager.DistributedJiniTransactionManager">
	<property name="space" ref="space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
    <property name="space" ref="space" />
	<property name="transactionManager" ref="transactionManager" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

{% lampon %} It is highly recommended to read the [transaction management chapter](http://static.springframework.org/spring/docs/3.0.x/reference/transaction.html) in the Spring reference documentation.

## Transaction Provider

OpenSpaces provides a pluggable transaction provider using the following interface:

{% highlight java %}
public interface TransactionProvider {
    Transaction getCurrentTransaction(Object transactionalContext, IJSpace space);
    int getCurrentTransactionIsolationLevel(Object transactionalContext);
}
{% endhighlight %}

OpenSpaces comes with a default transaction provider implementation, which uses Spring and its transaction manager in order to obtain the currently running transactions and automatically use them under transactional operations.

`GigaSpace` allows access to the current running transaction using the transaction provider. The following code example shows how the take operation can be performed using `IJspace` (users normally won't be required to do so):

{% highlight java %}
gigaSpace.getSpace().take(obj, gigaSpace.getCurrentTransaction(), 1000);
{% endhighlight %}

# Transaction Isolation Level

GigaSpaces supports three isolation levels: `READ_UNCOMMITTED`, `READ_COMMITTED` and `REPEATABLE_READ` (default). When using `GigaSpace`, the default isolation level that it will perform under can be defined in the following manner:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />

<os-core:giga-space id="gigaSpace" space="space" default-isolation="READ_COMMITTED"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
    <property name="defaultIsolationLevelName" value="READ_COMMITTED" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

IJSpace space = // get Space either by injection or code creation

GigaSpace gigaSpace = new GigaSpaceConfigurer(space)
                          .defaultIsolationLevel(TransactionDefinition.ISOLATION_READ_COMMITTED)
                          .gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

In addition, Spring allows you to define the isolation level on the transaction definition itself:

{% highlight java %}
@Transactional(readOnly = true)
public class DefaultFooService implements FooService {

    private GigaSpace gigaSpace;

    public void setGigaSpace(GigaSpace gigaSpace) {
    	this.gigaSpace = gigaSpace;
    }

    public Foo getFoo(String fooName) {
        // do something
    }

    // these settings have precedence for this method
    @Transactional(readOnly = false,
                   propagation = Propagation.REQUIRES_NEW,
                   isolation  = Isolation.READ_COMMITTED)
    public void updateFoo(Foo foo) {
        // do something
    }
}
{% endhighlight %}

In the above example, any operation performed using `GigaSpace` in the `updateFoo` method automatically works under the `READ_COMMITTED` isolation level.

# Default Operation Modifiers

You may configure default modifiers for the different operations in the `GigaSpace` interface. The default modifiers can be configured in the following manner:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />
<os-core:giga-space id="gigaSpace" space="space">
  <os-core:read-modifier value="FIFO"/>
  <os-core:change-modifier value="RETURN_DETAILED_RESULTS"/>
  <os-core:clear-modifier value="EVICT_ONLY"/>
  <os-core:count-modifier value="READ_COMMITTED"/>
  <os-core:take-modifier value="FIFO"/>

  <!-- to add more than one modifier, simply include all desired modifiers -->
  <os-core:write-modifier value="PARTIAL_UPDATE"/>
  <os-core:write-modifier value="UPDATE_ONLY"/>
</<os-core:giga-space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
  <property name="url" value="/./space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
  <property name="space" ref="space" />
  <property name="defaultWriteModifiers">
    <array>
      <bean id="updateOnly"
        class="org.openspaces.core.config.modifiers.WriteModifierFactoryBean">
        <property name="modifierName" value="UPDATE_ONLY" />
      </bean>
      <bean id="partialUpdate"
        class="org.openspaces.core.config.modifiers.WriteModifierFactoryBean">
        <property name="modifierName" value="PARTIAL_UPDATE" />
      </bean>
    </array>
  </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

IJSpace space = // get Space either by injection or code creation

GigaSpace gigaSpace = new GigaSpaceConfigurer(space)
  .defaultWriteModifiers(WriteModifiers.PARTIAL_UPDATE.add(WriteModifiers.UPDATE_ONLY))
  .defaultReadModifiers(ReadModifiers.FIFO)
  .defaultChangeModifiers(ChangeModifiers.RETURN_DETAILED_RESULTS)
  .defaultClearModifiers(ClearModifiers.EVICT_ONLY)
  .defaultCountModifiers(CountModifiers.READ_COMMITTED)
  .defaultTakeModifiers(TakeModifiers.FIFO)
  .gigaSpace();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

Any operation on the configured proxy will be treated as if the default modifiers were explicitly passed. If a certain operation requires passing an explicit modifier and also wishes to merge the existing default modifiers, the following  pattern should be used:

{% highlight java %}
GigaSpace gigaSpace = ...
gigaSpace.write(someObject, gigaSpace.getDefaultWriteModifiers().add(WriteModifiers.WRITE_ONLY));
{% endhighlight %}

For further details on each of the available modifiers see:

- [com.gigaspaces.client.ReadModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ReadModifiers.html)
- [com.gigaspaces.client.WriteModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html)
- [com.gigaspaces.client.TakeModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/TakeModifiers.html)
- [com.gigaspaces.client.CountModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/CountModifiers.html)
- [com.gigaspaces.client.ClearModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ClearModifiers.html)
- [com.gigaspaces.client.ChangeModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ChangeModifiers.html)

# Exception Hierarchy

OpenSpaces is built on top of the Spring [consistent exception hierarchy](http://static.springframework.org/spring/docs/2.0.x/reference/dao.html#dao-exceptions) by translating all of the different JavaSpaces exceptions and GigaSpaces exceptions into runtime exceptions, consistent with the Spring exception hierarchy. All the different exceptions exist in the `org.openspaces.core` package.

OpenSpaces provides a pluggable exception translator using the following interface:

{% highlight java %}
public interface ExceptionTranslator {

    DataAccessException translate(Throwable e);
}
{% endhighlight %}

A default implementation of the exception translator is automatically used, which translates most of the relevant exceptions into either Spring data access exceptions, or concrete OpenSpaces runtime exceptions (in the `org.openspaces.core` package).

## Exception handling for Batch Operations

Batch operations many throw the following Exceptions. Make sure you catch these and act appropriately:

- [org.openspaces.core.WriteMultiplePartialFailureException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/WriteMultiplePartialFailureException.html)
- [org.openspaces.core.WriteMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/WriteMultipleException.html)
- [org.openspaces.core.ReadMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/ReadMultipleException.html)
- [org.openspaces.core.TakeMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/TakeMultipleException.html)
- [org.openspaces.core.ClearException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/ClearException.html)
