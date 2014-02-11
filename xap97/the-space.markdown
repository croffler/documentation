---
layout: post
title:  The Space
categories: XAP97
weight: 150
parent: programmers-guide.html
---

{%comment%}
 getting-started.html
 50
{%endcomment%}

{% summary %}A Space is a logical in-memory service, which can store entries of information.{% endsummary %}


# Overview
A Space is a logical in-memory service, which can store entries of information. An entry is a domain object; In Java, an entry can be as simple a POJO or a SpaceDocument.

When a client connects to a space, a proxy is created that holds a connection which implements the space API. All client interaction is performed through this proxy.

The space is accessed via a programmatic interface which supports the following main functions:

- Write – the semantics of writing a new entry of information into the space.
- Read – read the contents of a stored entry into the client side.
- Take – get the value from the space and delete its content.
- Notify – alert when the contents of an entry of interest have registered changes.


# Embedded Space


A client communicating with a an embedded space performs all its operation via local connection. There is no network overhead when using this approach.

![embedded-space.jpg](/attachment_files/embedded-space.jpg)


Here is an example how to create an embedded space. The `UrlSpaceConfigurer` is used to configure the space url:

{% inittab os_space_emb|top %}
{% tabcontent Code %}

{% highlight java %}
GigaSpace gigaSpace = new GigaSpaceConfigurer(new UrlSpaceConfigurer("/./space")).gigaSpace();
{% endhighlight %}

{% endtabcontent %}

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
{% endinittab %}

The Embedded space can be used in a distributed architecture such as the replicated or partitioned clustered space:

{% indent %}
![replicated-space1.jpg](/attachment_files/replicated-space1.jpg)
{% endindent %}

A simple way to use the embedded space in a clustered architecture would be by deploying a [clustered space](./deploying-and-interacting-with-the-space.html) or packaging your application as a [Processing Unit](./packaging-and-deployment.html) and deploy it using the relevant SLA.



# Remote Space

A client communicating with a remote space performs all its operation via a remote connection. The remote space can be partitioned (with or without backups) or replicated (sync or async replication based).

{% indent %}
![remote-space.jpg](/attachment_files/remote-space.jpg)
{% endindent %}

Here is an example how a client application can create a proxy to interacting with a remote space:

{% inittab os_space_remote|top %}
{% tabcontent Code %}

{% highlight java %}

GigaSpace gigaSpace = new GigaSpaceConfigurer(new UrlSpaceConfigurer("jini://*/*/space")).gigaSpace();
{% endhighlight %}

{% endtabcontent %}
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

{% endinittab %}

{%info%}
A full description of the Space URL Properties can be found [here.](./the-space-url.html)
{%endinfo%}


## Reconnection
When working with a **remote space**, the space may become unavailable (network problems, processing unit relocation, etc.). For information on how such disruptions are handled and configured refer to [Proxy Connectivity](./proxy-connectivity.html).



# Local Cache

XAP supports a [Local Cache](./local-cache.html) (near cache) configuration. This provides a front-end client side cache that will be used with the `read` operations implicitly . The local cache will be loaded on demand or when you perform a `read` operation and will be updated implicitly by the space.

{% indent %}
![local_cache.jpg](/attachment_files/local_cache.jpg)
{% endindent %}

Here is an example for a `GigaSpace` construct with a local cache:

{% inittab os_local_cache|top %}
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

{% endinittab %}

# Local View

XAP supports a [Local View](./local-view.html) configuration. This provides a front-end client side cache that will be used with any `read` or `readMultiple` operations implicitly. The local view will be loaded on start and will be updated implicitly by the space.

{% indent %}
![local_view.jpg](/attachment_files/local_view.jpg)
{% endindent %}

Here is an example for a `GigaSpace` construct with a local cache:

{% inittab os_local_view|top %}
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
{% endinittab %}


# Space URL

A **Space URL** is a string that represents an address of a space. In short, there are two forms of space URLs:

* **Embedded** (e.g. `/./mySpace`) - Find an embedded (in-process) space called *mySpace*. If it doesn't exist it will be created automatically.
* **Remote** (e.g. `jini://*/*/mySpace`) - Find a remote space (hosted outside this process) called *mySpace*. If it doesn't exist an exception will be thrown.

The easiest way to create or find a space is to leverage XAP's integration with Spring, as explained in [The Space Component](the-space-component.html).

{%comment%}
If you prefer to use pure code without spring, use the [Configurer API](./programmatic-api-(configurers).html).
{%endcomment%}

#### Embedded Space

An **Embedded** space is a space that is hosted in your process. The URL format for locating such a space is:
{% highlight xml %}
/./<spaceName><?key1=val1><&keyN=valN>
{% endhighlight %}

For example, to find an embedded space called `foo` use `/./foo`.

If the requested space does not exist, it is automatically created and returned. If you wish to look for an existing space only, use `create=false` property (e.g. `/./foo?create=false`) - this will throw an exception if the requested space does not exist.

#### Remote Space

A **Remote** space is a space that is hosted in a different process. The URL format for locating such a space is:

{% highlight xml %}
jini://<hostName>:<port>/<containerName>/<spaceName><?key1=val1><&keyN=valN>
{% endhighlight %}

For example, to find a remote space called `foo` use `jini://*/*/foo`.

Let's examine that format:

* `jini://` - The prefix indicates to search for the space using the *JINI Lookup Service* protocol.
* `<hostName>:<port>` - Address of the JINI Lookup Service. Use `*` for multicast search, or specify a list of hostnames/ip addresses.
* `<containerName>` - Indicates a specific member in the cluster to find. Use `*` for finding any cluster member.
* `<spaceName>` - Name of space to find.

{%children%}

{%comment%}

# Basic Properties

There are multiple runtime configurations you may use when interacting with the space:

The Space support the following basic properties:


{: .table .table-bordered}
|Property |Description|Default|
|:-----------|:-----------------|:----------|:------|
|lookupGroups|The Jini Lookup Service group to use when running in multicast discovery mode. you may specify multiple groups comma separated| gigaspaces-X.X.X-XAP<Release>-ga |


{% togglecloak id=1 %}**Example**{% endtogglecloak %}
{% gcloak 1 %}
{% inittab os_simple_space|top %}
{% tabcontent java %}
{%highlight java%}
UrlSpaceConfigurer urlSpaceConfigurer = new UrlSpaceConfigurer("/./space").lookupGroups("test");
GigaSpace gigaSpace = new GigaSpaceConfigurer(urlSpaceConfigurer).gigaSpace();
{%endhighlight%}
{% endtabcontent %}
{% tabcontent Name Space %}
{%highlight xml%}
 <os-core:space id="space" url="/./space" />
 <os-core:giga-space id="gigaSpace" space="space" lookupGroups="test"
 </os-core:giga-space>
{%endhighlight%}
{% endtabcontent %}
{% endinittab %}
{% endgcloak %}

{: .table .table-bordered}
|Property|Description|Default|
|:-----------------|:----------|:------|
|lookupLocators |The Jini Lookup locators to use when running in unicast discovery mode. In the form of: host1:port1,host2:port2.| |

{% togglecloak id=2 %}**Example**{% endtogglecloak %}
{% gcloak 2 %}
{% inittab os_simple_space|top %}
{% tabcontent java %}
{%highlight java%}
UrlSpaceConfigurer urlSpaceConfigurer = new UrlSpaceConfigurer(url).lookupLocators("192.165.1.21:7888, 192.165.1.22:7888");
GigaSpace gigaSpace = new GigaSpaceConfigurer(urlSpaceConfigurer).gigaSpace();
{%endhighlight%}
{% endtabcontent %}
{% tabcontent Name Space %}
{%highlight xml%}
 <os-core:space id="space" url="/./space" />
 <os-core:giga-space id="gigaSpace" space="space" lookupLocators="192.165.1.21:7888, 192.165.1.22:7888"
 </os-core:giga-space>
{%endhighlight%}
{% endtabcontent %}
{% endinittab %}
{% endgcloak %}


{: .table .table-bordered}
|Property|Description|Default|Time Unit
|:-----------------|:----------|:------|:--------|
|lookupTimeout |The max timeout in milliseconds to use when running in multicast discovery mode to find a lookup service| 5000 | milliseconds |

{% togglecloak id=3 %}**Example**{% endtogglecloak %}
{% gcloak 3 %}
{% inittab os_simple_space|top %}
{% tabcontent java %}
{%highlight java%}
UrlSpaceConfigurer urlSpaceConfigurer = new UrlSpaceConfigurer(url).lookupTimeout(1000);
GigaSpace gigaSpace = new GigaSpaceConfigurer(urlSpaceConfigurer).gigaSpace();
{%endhighlight%}
{% endtabcontent %}
{% tabcontent Name Space %}
{%highlight xml%}
 <os-core:space id="space" url="/./space" />
 <os-core:giga-space id="gigaSpace" space="space" lookupTimout="1000"
 </os-core:giga-space>
{%endhighlight%}
{% endtabcontent %}
{% endinittab %}
{% endgcloak %}

{%endcomment%}