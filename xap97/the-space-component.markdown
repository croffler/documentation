---
layout: post
title:  The Space Component
categories: XAP97
parent: the-gigaspace-interface.html
weight: 900
---


{% summary %}A Space component allows you to create an `IJSpace` (or `JavaSpace`) based on a space URL.{% endsummary %}

# Overview

{%section%}
{%column width=60% %}
The different space components allow you to configure a space within a Spring application context (or a Processing Unit). A Space component allows you to create an `IJSpace` (or `JavaSpace`) with the most common practice of creating one based on a [Space URL](./space-url.html).
{%endcolumn%}

{%column width=35% %}
![OS_OnlyEmbedded.jpg](/attachment_files/OS_OnlyEmbedded.jpg)
{%endcolumn%}
{%endsection%}

Here is an example of creating a space within a Spring XML-based configuration:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space"
 	 lookup-timeout="10000"
 	 lookup-locators="10.10.10.10"
 	 lookup-groups="lookupGroupTest" />

{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="lookupGroups" value="lookupGroupTest" />
    <property name="lookupTimeout" value="10000" />
    <property name="lookupLocators" value="10.10.10.10" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

UrlSpaceConfigurer spaceConfigurer =
 	 new UrlSpaceConfigurer("/./space").
 	 lookupTimeout(10000).
 	 lookupGroups("lookupGroupTest").
 	 lookupLocators("10.10.10.10");

IJSpace space = spaceConfigurer.space();

// ...

// shutting down / closing the Space
spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

This example creates an embedded space (`IJSpace`) within the Spring application context (using the `/./` prefix) with the name `space` and a Spring bean id of the `space`.

{%comment%}
{% tip %}
 You may consider using the **[OpenSpaces Configuration API (Configurers)](./programmatic-api-(configurers).html)** in scenarios in which a Spring wiring them through XML configuration can not be used or you prefer using Code Based Configuration. Refer to the **[UrlSpaceConfigurer](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/space/UrlSpaceConfigurer.html)** for more details.
{% endtip %}
{%endcomment%}


## Basic Properties

The Space component support the following basic properties:


{: .table .table-bordered}
|XML Property|NameSpace Property|Description|Default|Time Unit
|:-----------|:-----------------|:----------|:------|:--------|
|lookupGroups|lookup-groups|The Jini Lookup Service group to use when running in multicast discovery mode. you may specify multiple groups comma separated| gigaspaces-X.X.X-XAP<Release>-ga | |
|lookupLocators|lookup-locators|The Jini Lookup locators to use when running in unicast discovery mode. In the form of: host1:port1,host2:port2.| | |
|lookupTimeout|lookup-timeout|The max timeout in milliseconds to use when running in multicast discovery mode to find a lookup service| 5000 | milliseconds |

# URL Properties

The `UrlSpaceFactoryBean` allows you to set different URL properties (as defined in the [Space URL](./space-url.html)), either explicitly using explicit properties, or using a custom `Properties` object. All of the current URL properties are exposed using explicit properties, in order to simplify the configuration.

Here is an example of a space with a specific schema working in FIFO mode, using specific lookup groups.

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

UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./space").fifo(true)
                                                                       .lookupGroups("test");
IJSpace space = spaceConfigurer.space();

// ...

// shutting down / closing the Space
spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Overriding Default Configuration Using General Properties

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
IJSpace space = spaceConfigurer.space();

// ...

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

# Embedded vs. Remote Space

When looking up or creating a space, OpenSpaces qualifies the state of the Space as either embedded or remote. An embedded space uses `/./` as the URL "protocol", and causes the space to be created and be part of the application context (or processing unit). A remote space is one that was looked up using one of the remote protocols (Jini or RMI). The previous example showed how to look up an embedded space, while the example below shows you how to look up a remote space using the Jini protocol (looks up a space called `space` on all machines under the same lookup group).

![OS_RemoteVSEmbedded.jpg](/attachment_files/OS_RemoteVSEmbedded.jpg)

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="jini://*/*/space" />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="jini://*/*/space" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("jini://**/**/space");
IJSpace space = spaceConfigurer.space();

// ...

// shutting down / closing the Space
spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Clustering

OpenSpaces views clustering as a deployment or runtime decision. The idea is not to configure a space with clustering information (`total_members`, `id`, etc.) within the Spring configuration, but allows the application context to be injected with this information when it is deployed (or run within the IDE).

Built on the same concept of Spring `ApplicationContextAware` callback interface, OpenSpaces defines `ClusterInfo` -- an object holding the specific Processing Unit instance cluster parameters (`id`, `total_members`, `backup_id`, etc.), and `ClusterInfoAware` -- allows any Spring bean to implement this interface and be injected with the cluster parameters.

The `UrlSpaceFactoryBean` implements this `ClusterInfoAware` and uses the `ClusterInfo` in order to automatically amend the Space URL with cluster parameters. The `ClusterInfo` is provided by external containers that can run a Processing Unit.

{% learn%}./obtaining-cluster-information.html{% endlearn %}

{% tip %}
Deploying a space (Stateful PU) may use the [Elastic Processing Unit](./elastic-processing-unit.html) allowing dynamic scale and space instances (primary/backup) rebalancing without any downtime.
{% endtip %}

# Reconnection

When working with a **remote space**, the space may become unavailable (network problems, processing unit relocation, etc.). For information on how such disruptions are handled and configured refer to [Proxy Connectivity](./proxy-connectivity.html).

# Primary/Backup

When working in clustered mode (schema) that includes a primary/backup schema, several components within the Processing Unit need to be aware of the current space mode and any changes made to it (such as event containers). Using Spring support for application events, two events are defined within OpenSpaces: `BeforeSpaceModeChangeEvent` and `AfterSpaceModeChangeEvent`. Both are raised when a space changes its mode from primary to backup or versa, and holds the current space mode.

![OS_PrimaryBackupCluster.jpg](/attachment_files/OS_PrimaryBackupCluster.jpg)

Custom beans that need to be aware of the space mode (for example, working directly against a cluster member, i.e. not using a clustered proxy of the space, and performing operations against the space only when it is in primary mode) can implement the Spring `ApplicationListener` and check for the mentioned events.

{% infosign %} OpenSpaces also provides the [Space Mode Context Loader](./space-mode-context-loader.html), which can load the Spring application context when it has become primary, and unload it when it moves to backup.

In embedded mode, the space factory bean registers with the space for space mode changes. The registration is performed on the actual space instance (and not a clustered proxy of it), and any events raised are translated to the equivalent OpenSpaces space mode change events. In remote mode, a single primary event is raised.

Space mode registration can be overridden and explicitly set within the space factory configuration. Here is an example of how it can be set (it cannot register for notifications even though it is an embedded space):

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" register-for-space-mode-notifications="false" />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="registerForSpaceModeNotifications" value="false" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

UrlSpaceConfigurer spaceConfigurer =
              new UrlSpaceConfigurer("/./space").registerForSpaceModeNotifications(false);
IJSpace space = spaceConfigurer.space();

// ...

// shutting down / closing the Space
spaceConfigurer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Primary Backup Notifications

A bean can implement the following interfaces to get notified about space mode changes:

{: .table .table-bordered}
| Interface | Implemented Method | When Invoked |
|:----------|:-------------------|:-------------|
| _SpaceBeforeBackupListener_ | void onBeforeBackup(BeforeSpaceModeChangeEvent event) | Before a space becomes backup |
| _SpaceBeforePrimaryListener_ | void onBeforePrimary(BeforeSpaceModeChangeEvent event) | Before a space becomes primary|
| _SpaceAfterBackupListener_ | void onAfterBackup(AfterSpaceModeChangeEvent event) | After a space becomes backup |
| _SpaceAfterPrimaryListener_ | void onAfterPrimary(AfterSpaceModeChangeEvent event) | After a space becomes primary |

{% highlight java %}
class MyBean implements SpaceBeforeBackupListener, SpaceAfterPrimaryListener {

    // invoked before a space becomes backup
    public void onBeforeBackup(BeforeSpaceModeChangeEvent event) {
        // Do something
    }

    // invoked after a space becomes primary
    public void onAfterPrimary(AfterSpaceModeChangeEvent event {
        // Do something
    }

}
{% endhighlight %}

If the bean would not implement any of the interfaces above, another option is to annotate the bean's methods that need to be invoked when a space mode changes.

{: .table .table-bordered}
| Annotation | Method Parameter | When Invoked |
|:-----------|:-----------------|:-------------|
| @PreBackup | _none_ or _BeforeSpaceModeChangeEvent_ | Before a space becomes backup |
| @PrePrimary | _none_ or _BeforeSpaceModeChangeEvent_ | Before a space becomes primary |
| @PostBackup | _none_ or _AfterSpaceModeChangeEvent_ | After a space becomes backup |
| @PostPrimary | _none_ or _AfterSpaceModeChangeEvent_ | After a space becomes primary |

{% highlight java %}
class MyBean {

    // invoked before a space becomes backup; gets the BeforeSpaceModeChangeEvent as a parameter
    @PreBackup
    public void myBeforeBackupMethod(BeforeSpaceModeChangeEvent event) {
        // Do something
    }

    // invoked after a space becomes primary; doesn't get any parameter.
    @PostPrimary
    public void myAfterPrimaryMethod() {
        // Do something
    }

}
{% endhighlight %}

In order to enable this feature, the following should be placed within the application context configuration:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:annotation-support />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="coreAnntoationSupport" class="org.openspaces.core.config.AnnotationSupportBeanDefinitionParser" />
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Listening for Space Mode Changed Events

When a remote client is interested to receive events when a space instance changing its runtime mode (from primary to backup or vise versa), it should implement the `SpaceModeChangedEventListener`. See below how:

Registering for the event using the [Administration API](./administration-and-monitoring-api.html):

{% highlight java %}
Admin admin = new AdminFactory().createAdmin();
Space space = admin.getSpaces().waitFor(spaceName, 10, TimeUnit.SECONDS);
SpaceModeChangedEventManager modeManager =  space.getSpaceModeChanged();
MySpaceModeListener spaceModeListener = new MySpaceModeListener (space);
modeManager.add(spaceModeListener);
{% endhighlight %}

The `MySpaceModeListener` should implement the `SpaceModeChangedEventListener` - see below simple example:

{% highlight java %}
public class MySpaceModeListener implements SpaceModeChangedEventListener{

	Space space ;
	public MySpaceModeListener (Space space)
	{
		this.space=space;
	}

	public void spaceModeChanged(SpaceModeChangedEvent event) {
		String partition_member = event.getSpaceInstance().getInstanceId()+"";
		if (event.getSpaceInstance().getBackupId() != 0)
		{
			partition_member = partition_member+ "_" + event.getSpaceInstance().getBackupId();
		}
	System.out.println("SpaceModeChangedEvent:  Space " + space.getName() +" - Instance " + partition_member +
			" moved into " + event.getNewMode());
	}
}
{% endhighlight %}

# Security

A secured space should be configured with a security context so that it can be accessed (when connecting to it remotely). Here is an example of how this can be configured:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="jini://*/*/space">
    <os-core:security username="sa" password="adaw@##$" />
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="jini://*/*/space" />
    <property name="securityConfig">
        <bean class="org.openspaces.core.space.SecurityConfig">
            <property name="username" value="sa" />
            <property name="password" value="adaw@##$" />
        </bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

Here is an example of how to define security with an embedded space. In this case, we enable security and specify the username and password.

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space">
    <os-core:security username="sa" password="adaw@##$" />
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="securityConfig">
        <bean class="org.openspaces.core.space.SecurityConfig">
            <property name="username" value="sa" />
            <property name="password" value="adaw@##$" />
        </bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

It is possible to configure the space to be secured using deploy time properties (bean level properties), without declaring the security element. The `security.username` and `security.password` can be provided, and the spaces defined within the processing unit are automatically secured.

{% refer %}For more details, refer to the [Space Security](./security.html) section.{% endrefer %}

# Space Filters

The `UrlSpaceFactoryBean` allows you to configure [Space Filters](./space-filters.html). It uses the space support for a `FilterProvider`, which is a wrapper for an `ISpaceFilter` implementation and its characteristics (such as priority, `activeWhenBackup`). This allows you to provide space filters without changing the space schema.

{% exclamation %} Space Filters can only be used with embedded spaces.

## ISpaceFilter

An actual implementation of the `ISpaceFilter` interface can be provided using the `SpaceFilterProviderFactory` class. Here is a very simple example of an `ISpaceFilter` implementation:

{% highlight java %}
public class SimpleFilter implements ISpaceFilter {

    public void init(IJSpace space, String filterId, String url, int priority)
                throws RuntimeException {
        // perform operations on init
    }

    public void process(SpaceContext context, ISpaceFilterEntry entry, int operationCode)
                throws RuntimeException {
        // process single entry filter operations
    }

    public void process(SpaceContext context, ISpaceFilterEntry[] entries, int operationCode)
                throws RuntimeException {
        // process multiple entries filter operation (such as update)
    }

    public void close() throws RuntimeException {
        // perform operation when filter closes
    }
}
{% endhighlight %}

The following Spring configuration registers this filter for before write (`0`), before read (`2`), and before take (`3`) operations:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleFilter" class="eg.SimpleFilter" />

<os-core:space id="space" url="/./space">
    <os-core:space-filter priority="2">
        <os-core:filter ref="simpleFilter" />
        <os-core:operation code="0" />
        <os-core:operation code="2" />
        <os-core:operation code="3" />
    </os-core:space-filter>
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleFilter" class="eg.SimpleFilter" />

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="filterProviders">
        <list>
            <bean class="org.openspaces.core.space.filter.SpaceFilterProviderFactory">
                <property name="filter" ref="simpleFilter" />
                <property name="priority" value="2" />
                <property name="operationCodes">
                    <list>
                        <value>0</value>
                        <value>2</value>
                        <value>3</value>
                    </list>
                </property>
            </bean>
        </list>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## Delegate Filters

OpenSpaces comes with delegate implementations of `ISpaceFilter`, allowing you to use either annotations or explicit method listings in order to use POJOs as space filters.

Here is an example of a simple POJO filter using annotations:

{% highlight java %}
public class SimpleFilter {

    @OnFilterInit
    void init() {
    }

    @OnFilterClose
    void close() {
    }

    @BeforeWrite
    public void beforeWrite(Message entry) {
        // ...
    }

    @AfterWrite
    public void afterWrite(Echo echo) {
        // ...
    }

    @BeforeRead
    public void beforeRead(ISpaceFilterEntry entry) {
        // ...
    }

    @BeforeTake
    public void beforeTake(Message entry, int operationCode) {
        // ...
    }

    @AfterRead
    public void afterRead(Echo echo) {
        // ...
    }

    // called for each matching object
    @AfterReadMultiple
    public void afterReadMultiple(Echo echo) {
        // ...
    }

    // called for each matching object
    @AfterTakeMultiple
    public void afterTakeMultiple(Echo echo) {
        // ...
    }
}
{% endhighlight %}

This example (which also applies to explicit method listings, just without the annotations) demonstrates different options to mark methods as filter operation callbacks or filter lifecycle callbacks.

First, note the `beforeRead(ISpaceFilterEntry entry)` method (the method name can be any name of your choice). The method accepts the same `ISpaceFilterEntry` that the `ISpaceFilter` process method uses (which is usually used for extracting the actual template or Entry). With the `beforeWrite(Message entry)` method, the delegate automatically detects that the first parameter is not an `ISpaceFilterEntry`, and uses it to extract the actual Entry, which is used to invoke the method with (in our case) `Message`. When using Entry-type classes in the filter callback, other types that are not assignable to the Entry parameter type, do not cause the filter method callback to be invoked. (In our case, `beforeWrite` is not invoked for the echo object.)

{% exclamation %} When either annotations or explicit method listings are used, only a single method per operation can be defined.

The delegate filter shown above, can be configured in Spring using the following XML:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleFilter" class="test.SimpleFilter" />

<os-core:space id="space" url="/./space">
    <os-core:annotation-adapter-filter priority="2">

        <os-core:filter ref="simpleFilter" />
    </os-core:annotation-adapter-filter>
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleFilter" class="test.SimpleFilter" />

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="filterProviders">
    	<bean class="org.openspaces.core.space.filter.AnnotationFilterFactoryBean">
    	    <property name="filter" ref="simpleFilter" />
    	    <property name="priority" value="2" />
    	</bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

The following Spring configuration XML shows how the filter can be configured, using explicit method listings. (In this case, annotations are not required.)

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleFilter" class="test.SimpleFilter" />

<os-core:space id="space" url="/./spaceAdapterSimpleFilterMethod">
    <os-core:method-adapter-filter priority="2"
                                   filter-init="init" filter-close="close"
                                   before-write="beforeWrite" after-write="afterWrite"
                                   before-read="beforeRead" before-take="beforeTake">
        <os-core:filter ref="simpleFilter"/>
    </os-core:method-adapter-filter>
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleFilter" class="test.SimpleFilter" />

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="filterProviders">
    	<bean class="org.openspaces.core.space.filter.MethodFilterFactoryBean">
    	    <property name="filter" ref="simpleFilter" />
    	    <proeprty name="priority" value="2" />
    	    <property name="filterInit" value="init" />
    	    <property name="filterClose" value="close" />
    	    <property name="beforeWrite" value="beforeWrite" />
    	    <property name="afterWrite" value="afterWrite" />
    	    <property name="beforeRead" value="beforeRead" />
    	    <property name="beforeTake" value="beforeTake" />
    	</bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## Accessing a Space within a Space Filter

Accessing a space within a space filter can cause a cycle construction exception, since the space can not be injected to the filter (because the space was not constructed yet). There are options to solve this with pure Spring, but OpenSpaces provides a simpler option by using the [GigaSpacesLateContext](./pojo-grid-annotations.html) annotation.

# Space Replication Filters

The `UrlSpaceFactoryBean` allows you to configure [Cluster Replication Filters](./cluster-replication-filters.html). It uses the space support for a `ReplicationFilterProvider` which is a wrapper for an `IReplicationFilter` implementation and its characteristics (such as `activeWhenBackup`). This allows you to provide space replication filters without changing the space schema.

{% exclamation %} Space replication filters can only be used with embedded spaces.

A simple implementation of `IReplicationFilter` is shown below:

{% highlight java %}
public class SimpleReplicationFilter implements IReplicationFilter {

    public void init(IJSpace space, String paramUrl, ReplicationPolicy replicationPolicy) {
        // init logic here
    }

    public void process(int direction, IReplicationFilterEntry replicationFilterEntry, String remoteSpaceMemberName) {
        // process logic here
    }

    public void close() {
        // close logic here
    }
}
{% endhighlight %}

The following configuration shows how it can be injected:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleReplicationFilter" class="eg.SimpleReplicationFilter" />

<os-core:space id="space" url="/./space">
    <os-core:space-replication-filter>
        <os-core:input-filter ref="simpleReplicationFilter" />
        <os-core:output-filter ref="simpleReplicationFilter" />
    </os-core:space-replication-filter>
</os-core:space>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleReplicationFilter" class="eg.SimpleReplicationFilter" />

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="replicationFilterProvider">
        <bean class="org.openspaces.core.space.filter.replication.DefaultReplicationFilterProviderFactory">
            <property name="inputFilter" ref="simpleReplicationFilter" />
            <property name="outputFilter" ref="simpleReplicationFilter" />
        </bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Space Persistency

When constructing a space, it is possible to provide [Space Persistency](./space-persistency.html) extensions using Spring-based configuration (instead of using the space schema). Here is an example of how it can be defined:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="org.hsqldb.jdbcDriver"/>
    <property name="url" value="jdbc:hsqldb:hsql://localhost:9001"/>
    <property name="username" value="sa"/>
    <property name="password" value=""/>
</bean>

<bean id="sessionFactory" class="org.springframework.orm.hibernate3.LocalSessionFactoryBean">
    <property name="dataSource" ref="dataSource"/>
    <property name="mappingResources">
        <list>
            <value>Person.hbm.xml</value>
        </list>
    </property>
    <property name="hibernateProperties">
        <props>
            <prop key="hibernate.dialect">org.hibernate.dialect.HSQLDialect</prop>
            <prop key="hibernate.cache.provider_class">org.hibernate.cache.NoCacheProvider</prop>
            <prop key="hibernate.cache.use_second_level_cache">false</prop>
            <prop key="hibernate.cache.use_query_cache">false</prop>
            <prop key="hibernate.hbm2ddl.auto">update</prop>
        </props>
    </property>
</bean>

<bean id="hibernateSpaceDataSource" class="com.gigaspaces.datasource.hibernate.DefaultHibernateSpaceDataSource">
    <property name="sessionFactory" ref="sessionFactory"/>
</bean>

<os-core:space id="space" url="/./space" schema="persistent" space-data-source="hibernateSpaceDataSource" />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="dataSource" class="org.apache.commons.dbcp.BasicDataSource" destroy-method="close">
    <property name="driverClassName" value="org.hsqldb.jdbcDriver"/>
    <property name="url" value="jdbc:hsqldb:hsql://localhost:9001"/>
    <property name="username" value="sa"/>
    <property name="password" value=""/>
</bean>

<bean id="sessionFactory" class="org.springframework.orm.hibernate3.LocalSessionFactoryBean">
    <property name="dataSource" ref="dataSource"/>
    <property name="mappingResources">
        <list>
            <value>Person.hbm.xml</value>
        </list>
    </property>
    <property name="hibernateProperties">

        <props>
            <prop key="hibernate.dialect">org.hibernate.dialect.HSQLDialect</prop>
            <prop key="hibernate.cache.provider_class">org.hibernate.cache.NoCacheProvider</prop>
            <prop key="hibernate.cache.use_second_level_cache">false</prop>
            <prop key="hibernate.cache.use_query_cache">false</prop>
            <prop key="hibernate.hbm2ddl.auto">update</prop>
        </props>
    </property>
</bean>

<bean id="hibernateSpaceDataSource" class="com.gigaspaces.datasource.hibernate.DefaultHibernateSpaceDataSource">
    <property name="sessionFactory" ref="sessionFactory"/>
</bean>

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
    <property name="scheam" value="persistent" />
    <property name="spaceDataSource" ref="hibernateSpaceDataSource" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

The above example uses Spring built-in support for configuring both a custom JDBC `DataSource` and a Hibernate `SessionFactory` to define and use the GigaSpaces built-in `HibernateSpaceDataSource`. The GigaSpaces data source is then injected into the space construction (note the specific schema change), and causes the space to use it.

{% lampon %} This configuration can also be used with the GigaSpaces [Mirror Service](./asynchronous-persistency-with-the-mirror.html) deployed as a Processing Unit.

# Schema

The Space component schema and complete configuration options are described below:

{% indent %}
![space_schema.jpg](/attachment_files/space_schema.jpg)
{% endindent %}

{% children %}
