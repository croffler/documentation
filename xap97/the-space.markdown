---
layout: post
title:  The Space Interface
categories: XAP97
weight: 150
parent: programmers-guide.html
---



{% summary %}A Space is a logical in-memory service, which can store entries of information.{% endsummary %}


# Overview
A Space is a logical in-memory service, which can store entries of information. An entry is a domain object; In Java, an entry can be as simple a POJO or a SpaceDocument.

When a client connects to a space, a proxy is created that holds a connection which implements the space API. All client interaction is performed through this proxy.

The space is accessed via a programmatic interface which supports the following main functions:

- Write – the semantics of writing a new entry of information into the space.
- Read – read the contents of a stored entry into the client side.
- Take – get the value from the space and delete its content.
- Notify – alert when the contents of an entry of interest have registered changes.

{%learn%}./the-space-operations.html{%endlearn%}

The space proxy is created through the `UrlSpaceConfigurer`. Several configuration parameters are available.  {%learn%}./the-space-configuration.html{%endlearn%}


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
A full description of the Space URL Properties can be found [here.](./the-space-configuration.html)
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
{% tabcontent   Namespace   %}

{% highlight xml %}
<os-core:space id="space" url="jini://*/*/space" />
<os-core:local-cache id="localCacheSpace" space="space"/>
<os-core:giga-space id="localCache" space="localCacheSpace"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

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
{% tabcontent   Namespace   %}

{% highlight xml %}
<os-core:space id="space" url="jini://*/*/space" />

<os-core:local-view id="localViewSpace" space="space">
    <os-core:view-query class="com.example.Message1" where="processed = true"/>
    <os-core:view-query class="com.example.Message2" where="priority > 3"/>
</os-core:local-view>

<os-core:giga-space id="localView" space="localViewSpace"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

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

{%learn %}./security.html{%endlearn %}


# Persistency

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



{% info %}
This configuration can also be used with the GigaSpaces [Mirror Service](./asynchronous-persistency-with-the-mirror.html) deployed as a Processing Unit.
{%endinfo%}

{%learn%}space-persistency.html{%endlearn%}