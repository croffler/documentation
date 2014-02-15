---
layout: post
title:  Context Loader
categories: XAP97
parent: the-space.html
weight: 6000
---


{% summary %}Allows you to load a Spring application context only when the Processing Unit or space is in primary mode, and unload it when the Processing Unit or space is in backup mode.{% endsummary %}

# Overview

Most of the OpenSpaces built-in components take into account the state of the space (mainly applicable when starting an embedded space within the Processing Unit). This is important when working directly on a cluster member, since operations cannot be performed directly on a backup member.

Many times, custom beans or POJOs would like to operate directly on the cluster member. To do this, they need to take the space mode into account -- by not performing any actions against the cluster member when it is in backup mode, and by starting to perform all relevant actions when the space mode changes to primary.

Using the custom space mode events described in the [Space](./the-space-component.html) section, the bean can register for such events (by implementing the Spring `ApplicationListener` interface), and perform relevant actions based on the space mode event.

OpenSpaces provides a simpler solution, allowing you to load a Spring application context (based on a separate Spring XML configuration file) only when the Processing Unit or space is in primary mode, and unload it when the Processing Unit or space is in backup mode. If we take the following simple bean:

{% highlight java %}
public class SpaceModeContextBean implements InitializingBean, DisposableBean {

    @GigaSpaceContext(name = "gigaSpace")
    private GigaSpace gigaSpace;

    public void afterPropertiesSet() throws Exception {
        System.out.println("SPACE MODE BEAN LOADED, SPACE [" + gigaSpace + "]");
    }

    public void destroy() throws Exception {
        System.out.println("SPACE MODE BEAN DESTROYED, SPACE [" + gigaSpace + "]");
    }
}
{% endhighlight %}

and the following Spring XML definition constructing this bean (stored in a separate XML file than the Processing Unit definition called `mode.xml`):

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:giga-space-context />

<bean id="spaceModeContextBean" class="org.openspaces.example.data.processor.SpaceModeContextBean"/>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<!--
    Enables the usage of @GigaSpaceContext annotation based injection.
-->
<bean id="gsContext" class="org.openspaces.core.context.GigaSpaceContextBeanPostProcessor" />

<bean id="spaceModeContextBean" class="org.openspaces.example.data.processor.SpaceModeContextBean"/>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

with the following Processing Unit definition:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:space id="space" url="/./space" />

<os-core:giga-space id="gigaSpace" space="space"/>

<!--
    Enables the usage of @GigaSpaceContext annotation based injection.
-->
<os-core:giga-space-context/>

<os-core:context-loader id="modeExample" location="classpath:/META-INF/spring/mode/mode.xml"/>
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

<!--
    Enables the usage of @GigaSpaceContext annotation based injection.
-->
<bean id="gsContext" class="org.openspaces.core.context.GigaSpaceContextBeanPostProcessor" />

<bean id="modeExample" class="org.openspaces.core.space.mode.SpaceModeContextLoader">
    <property name="location" value="classpath:/META-INF/spring/mode/mode.xml" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

{% tip %}
If there is more then one gigaSpace proxy in the pu you should bind the context to the gigaSpace instance by setting the giga-space property e.g:
<os-core:context-loader id="modeExample" location="classpath:/META-INF/spring/mode/mode.xml" giga-space="gigaSpace">
{% endtip %}

we can see that the `SpaceModeContextBean` `afterPropertiesSet` callback is called when the Processing Unit instance is in primary mode. When it moves to backup mode, the Spring application context is unloaded, and the `destroy` callback is invoked. Note the usage of the `GigaSpace` instance, which is defined in the Processing Unit definition, as part of the bean defined in the `mode.xml` file. This is allowed because of the fact that the Processing Unit definition acts as a parent application context to the application context loaded with `mode.xml`.
