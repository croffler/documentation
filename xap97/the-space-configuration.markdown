---
layout: post
title:  Configuration
categories: XAP97
parent: the-space.html
weight: 1000
---


{% summary %}Describes the Space URL and properties to configure a Space{% endsummary %}

# Overview

When a client connects to a space, a proxy is created that holds a connection to the space. All client interaction is performed through this proxy.
This proxy provides a simpler space API using the [GigaSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html) interface.
This proxy is created with a Space URL and optional parameters.

# Space URL

A **Space URL** is a string that represents an address of a space. In short, there are two forms of space URLs:

* **Embedded** (e.g. `/./mySpace`) - Find an embedded (in-process) space called *mySpace*. If it doesn't exist it will be created automatically.
* **Remote** (e.g. `jini://*/*/mySpace`) - Find a remote space (hosted outside this process) called *mySpace*. If it doesn't exist an exception will be thrown.


### Embedded Space

An **Embedded** space is a space that is hosted in your process. The URL format for locating such a space is:
{% highlight xml %}
/./<spaceName><?key1=val1><&keyN=valN>
{% endhighlight %}

For example, to find an embedded space called `mySpace` use `/./mySpace`.

If the requested space does not exist, it is automatically created and returned. If you wish to look for an existing space only, use `create=false` property (e.g. `/./foo?create=false`) - this will throw an exception if the requested space does not exist.

### Remote Space

A **Remote** space is a space that is hosted in a different process. The URL format for locating such a space is:

{% highlight xml %}
jini://<hostName>:<port>/<containerName>/<spaceName><?key1=val1><&keyN=valN>
{% endhighlight %}

For example, to find a remote space called `foo` use `jini://*/*/mySpace`.

Let's examine that format:

* `jini://` - The prefix indicates to search for the space using the *JINI Lookup Service* protocol.
* `<hostName>:<port>` - Address of the JINI Lookup Service. Use `*` for multicast search, or specify a list of hostnames/ip addresses.
* `<containerName>` - Indicates a specific member in the cluster to find. Use `*` for finding any cluster member.
* `<spaceName>` - Name of space to find.


jini://*/myhost:3400_myContainer2_mySpace


# URL Properties

The space URL supports the following basic properties:


{: .table .table-bordered}
|XML Property|NameSpace Property|Description|Default|Time Unit
|:-----------|:-----------------|:----------|:------|:--------|
|lookupGroups|lookup-groups|The Jini Lookup Service group to use when running in multicast discovery mode. you may specify multiple groups comma separated| gigaspaces-X.X.X-XAP<Release>-ga | |
|lookupLocators|lookup-locators|The Jini Lookup locators to use when running in unicast discovery mode. In the form of: host1:port1,host2:port2.| | |
|lookupTimeout|lookup-timeout|The max timeout in milliseconds to use when running in multicast discovery mode to find a lookup service| 5000 | milliseconds |
|schema|schema|The schema type to use| |   |
|create| |||
|versioned|versioned| indicates if the space supports versioning |  | |
| noWriteLease|no-write-lease|  |  | |
| mirror| mirror| |  | |
| fifo|fifo|  |  | |
| registerForSpaceModeNotification|register-for-space-mode-notification| |  | |
| spaceDataSource|space-data-source| |  | |
| spaceSyncEndpoint|space-sync-endpoint|  |  | |
| enableMemberAliveIndicator|enable-member-alive-indicator|  |  | |

The `UrlSpaceFactoryBean` allows you to set different URL properties, either explicitly using explicit properties, or using a custom `Properties` object. All of the current URL properties are exposed using explicit properties, in order to simplify the configuration.

Here is an example of a space working in FIFO mode, using specific lookup groups.

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}
  <os-core:space id="space" url="/./space" fifo="true" lookup-groups="test" />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}
<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="fifo" value="true" />
    <property name="lookupGroups" value="test" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

   // Create the url
   UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./space").fifo(true)
                                                                       .lookupGroups("test");
   // Create the url with arguments
   UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./space?fifo=true&lookupGroups=test");

   // Create the url with properties
   UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./space")
       .addProperty("fifo","true")
       .addProperty("lookupGroups","test");
   // .....
   // Create the Proxy
   GigaSpace gigaSpace = new GigaSpaceConfigurer(spaceConfigurer).gigaSpace();

   // shutting down / closing the Space
   spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

### Overriding Default Configuration Using General Properties

The space allows you to override specific schema configuration element values using the `Properties` object, that uses an XPath-like navigation as the name value. The `UrlSpaceFactoryBean` allows you to set the `Properties` object, specifying it within the Spring configuration.

{% tip title=Which component's configuration can be overridden? %}
The general properties are used to override various components such as the space, space container, cluster schema properties, space proxy/client configuration, space URL attributes and other system and environmental properties.
{% endtip %}

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space">
    <os-core:properties>
        <props>
            <prop key="space-config.engine.cache_policy">0</prop>
        </props>
    </os-core:properties>
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}
<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="properties">
        <props>
            <prop key="space-config.engine.cache_policy">0</prop>
        </props>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

   UrlSpaceConfigurer spaceConfigurer =
    new UrlSpaceConfigurer("/./space").addProperty("space-config.engine.cache_policy", "0");

   // Create the proxy
   GigaSpace gigaSpace = new GigaSpaceConfigurer(new UrlSpaceConfigurer(url)).gigaSpace();

   // shutting down / closing the Space
   spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

Popular overrides:

- [Memory Manager Settings](./memory-management-facilities.html#Memory Manager Parameters)
- [Replication Settings](./replication-parameters.html)
- [Replication Redo-log Settings](./controlling-the-replication-redo-log.html#Redo Log Capacity Configuration)
- [Proxy Connectivity Settings](./proxy-connectivity.html#Configuration)
- [Persistency Settings](./space-persistency-advanced-topics.html#Properties)



# The Space Proxy

The `GigaSpace` Spring Bean provides a simple way to configure a proxy to be injected into the relevant Bean.

Here is an example on how to create the proxy:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}
  <os-core:space id="space" url="/./space" />
  </os-core:giga-space id="mySpace" space="space" />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}
<os-core:space id="space" url="/./space">
<bean id="mySpace" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

   // Create the URL
   UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./mySpace");

   // Create the Proxy
   GigaSpace gigaSpace = new GigaSpaceConfigurer(spaceConfigurer).gigaSpace();

   // shutting down -- closing the Space
   spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Proxy Properties

The `GigaSpace` Bean can have the following elements:

{: .table .table-bordered}
|Element|Description|Required|Default Value|
|:------|:----------|:-------|:------------|
|space|This can be an embedded space , remote space , local view or local cache. |YES| |
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

Here is an example of the `GigaSpace` Bean:

{% inittab gigaspace|top %}
{% tabcontent Namespace %}

{% highlight xml %}

 <os-core:space id="mySpace" url="/./space"/>

 <os-core:giga-space id="gigaSpaceClustered" space="mySpace" clustered="true"
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



### Examples

Here are some examples on how to configure the Space URL and the proxy:

Declaring a remote space with a transaction manager:

{% highlight java %}
<tx:annotation-driven transaction-manager="transactionManager"/>

<os-core:space id="space" url="jini://*/*/space" />
<os-core:giga-space id="gigaSpace" space="space" tx-manager="transactionManager"/>
{% endhighlight %}


Declaring a remote space with a transaction manager and creating an embedded space:

{% highlight java %}
<os-core:space id="spaceRemote" url="jini://*/*/space" />
<os-core:giga-space id="gigaSpaceRemote" space=" spaceRemote"  tx-manager="transactionManager1"/>

<os-core:space id="spaceEmbed" url="/./space" />
<os-core:giga-space id="gigaSpaceEmbed" space="spaceEmbed"  tx-manager="transactionManager2"/>
{% endhighlight %}

Declaring a remote space creating a local view:

{% highlight java %}
<os-core:space id="spaceRemote" url="jini://*/*/space" />
<os-core:local-view id="localViewSpace" space="spaceRemote">
	<os-core:view-query class="com.example.Message1" where="processed = true"/>
</os-core:local-view>
<os-core:giga-space id="gigaSpaceLocalView" space="localViewSpace"/>
{% endhighlight %}

Declaring a remote space with a local view , a regular remote space (without a view) and an embedded space:

{% highlight java %}
<os-core:space id="spaceRemote" url="jini://*/*/space" />
	<os-core:local-view id="localViewSpace" space="spaceRemote">
	<os-core:view-query class="com.example.Message1" where="processed = true"/>
</os-core:local-view>

<os-core:giga-space id="gigaSpaceLocalView" space="localViewSpace"/>
<os-core:giga-space id="gigaSpaceRemote" space="spaceRemote"  tx-manager="transactionManager1"/>

<os-core:space id="spaceEmbed" url="/./space" />
<os-core:giga-space id="gigaSpaceEmbed" space="spaceEmbed"  tx-manager="transactionManager2"/>
{% endhighlight %}

{% note %}
The application is always injected with `os-core:giga-space` bean that wraps always a `os-core:space`.
{% endnote %}



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

  UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./space");

  GigaSpace gigaSpace = new GigaSpaceConfigurer(spaceConfigurer)
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

- [ReadModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ReadModifiers.html)
- [WriteModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html)
- [TakeModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/TakeModifiers.html)
- [CountModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/CountModifiers.html)
- [ClearModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ClearModifiers.html)
- [ChangeModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ChangeModifiers.html)

# Exception Hierarchy

OpenSpaces is built on top of the Spring [consistent exception hierarchy](http://static.springframework.org/spring/docs/2.0.x/reference/dao.html#dao-exceptions) by translating all of the different JavaSpaces exceptions and GigaSpaces exceptions into runtime exceptions, consistent with the Spring exception hierarchy. All the different exceptions exist in the `org.openspaces.core` package.

OpenSpaces provides a pluggable exception translator using the following interface:

{% highlight java %}
public interface ExceptionTranslator {

    DataAccessException translate(Throwable e);
}
{% endhighlight %}

A default implementation of the exception translator is automatically used, which translates most of the relevant exceptions into either Spring data access exceptions, or concrete OpenSpaces runtime exceptions (in the `org.openspaces.core` package).

### Exception handling for Batch Operations

Batch operations many throw the following Exceptions. Make sure you catch these and act appropriately:

- [WriteMultiplePartialFailureException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/WriteMultiplePartialFailureException.html)
- [WriteMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/WriteMultipleException.html)
- [ReadMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/ReadMultipleException.html)
- [TakeMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/TakeMultipleException.html)
- [ClearException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/ClearException.html)


# Basic Guidelines

{%info title=Guidelines for using the **GigaSpace** proxy:%}

- The variable represents a remote or embedded space proxy (for a single space or clustered) and **should be constructed only** once throughout the lifetime of the application process.
- You should treat the variable as a singleton to be shared across multiple different threads within your application.
- The interface is thread safe and there is no need to create a GigaSpace variable per application thread.
- In case the space has been fully terminated (no backup or primary instances running any more) the client space proxy will try to reconnect to the space up to a predefined timeout based on the [Proxy Connectivity](./proxy-connectivity.html) settings. If it fails to reconnect, an error will be displayed.
- Within a single Processing Unit (or Spring application context), several GigaSpace instances can be defined, each with different characteristics, all will be interacting with the same remote space.
{%endinfo%}