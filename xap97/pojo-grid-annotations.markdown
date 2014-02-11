---
layout: post
title:  Grid Metadata
categories: XAP97
parent: pojo-metadata.html
weight: 400
---

{% summary %}This section explains the different data grid metadata.{% endsummary %}




# GigaSpaceContext

{: .table .table-bordered}
|Attribute Annotation| @GigaSpaceContext  |
|Description         | In previous Spring releases, Spring only allowed you to inject the GigaSpace instance using setter injection or constructor injection. XAP extended this injection mechanism by allowing you to use annotations to inject a GigaSpace instance. As of Spring 2.5, this is no longer required since Spring support annotation based injection using the @Resource or @Autowired annotations.  |


{% togglecloak id=1 %}**Annotation**{% endtogglecloak %}
{% gcloak 1 %}
{%highlight java%}

//There can be more than one GigaSpace instance defined

public class MyService {

    @GigaSpaceContext(name="directGigaSpace")
    private GigaSpace directGigaSpace;

    @GigaSpaceContext(name="clusteredGigaSpace")
    private GigaSpace clusteredGigaSpace;
}
{%endhighlight%}
{% endgcloak %}

There is no need to have a setter for the GigaSpace instance, and by annotating it with GigaSpaceContext, a GigaSpace instance is automatically injected. In order to enable this feature, the following element needs to be configured in the Spring application context:

{% togglecloak id=11 %}**Spring Configuration**{% endtogglecloak %}
{% gcloak 11 %}
{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

 {% highlight xml %}

 <os-core:giga-space-context/>

 <os-core:space id="space" url="/./space" />

 <os-core:giga-space id="directGigaSpace" space="space"/>

 <os-core:giga-space id="clusteredGigaSpace" space="space" clustered="true"/>

 <bean id="myService" class="eg.MyService" />
 {% endhighlight %}

 {% endtabcontent %}
 {% tabcontent Plain XML %}

 {% highlight xml %}

 <bean id="gigaSpaceContext" class="org.openspaces.core.context.GigaSpaceContextBeanPostProcessor" />

 <bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
     <property name="url" value="/./space" />
 </bean>

 <bean id="directGigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
 	<property name="space" ref="space" />
 </bean>

 <bean id="clusteredGigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
 	<property name="space" ref="space" />
 	<proeprty name="clustered" value="true" />
 </bean>

 <bean id="myService" class="eg.MyService" />
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}
{% endgcloak %}


# GigaSpaceLateContext

{: .table .table-bordered}
|Class Annotation    |  |
|Attribute Annotation| @GigaSpaceLateContext  |
|Description         |  XAP allows you to define beans (such as filters), that are later injected to the actual space. If such beans require access to the GigaSpace instance, a cyclic dependency occurs (GigaSpace requires the Space, but the Space requires the filter injection). XAP allows you to use the same annotation-based injection mechanism in order to inject the GigaSpace instance at a different lifecycle stage. |

{% togglecloak id=2 %}**Annotation**{% endtogglecloak %}
{% gcloak 2 %}
{%highlight java%}
public class MyService {

    @GigaSpaceLateContext
    private GigaSpace gigaSpace;

}
{%endhighlight%}
{% endgcloak %}

There is no need to have a setter for the `GigaSpace` instance, and by annotating it with `GigaSpaceLateContext`, a `GigaSpace` instance is automatically injected. In order to enable this feature, the following element needs to be configured in the Spring application context:

{% togglecloak id=21 %}**Spring Configuration**{% endtogglecloak %}
{% gcloak 21 %}
{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<os-core:giga-space-late-context/>

<os-core:space id="space" url="/./space" />

<os-core:giga-space id="gigaSpace" space="space"/>

<bean id="myService" class="eg.MyService" />
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="gigaSpaceContext" class="org.openspaces.core.context.GigaSpaceLateContextBeanPostProcessor" />

<bean id="space" class="org.openspaces.core.space.UrlSpaceFactoryBean">
    <property name="url" value="/./space" />
</bean>

<bean id="gigaSpace" class="org.openspaces.core.GigaSpaceFactoryBean">
	<property name="space" ref="space" />
</bean>

<bean id="myService" class="eg.MyService" />
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}
{% endgcloak %}


# ClusterInfoContext

{: .table .table-bordered}
|Attribute Annotation| @ClusterInfoContext  |
|Description         | This annotation injects cluster information into the class.  |


{% togglecloak id=3 %}**Example**{% endtogglecloak %}
{% gcloak 3 %}
{%highlight java%}
public class Process {

    @ClusterInfoContext
    ClusterInfo  clusterInfo;

    Integer instanceId = clusterInfo.getInstanceId();
}
{%endhighlight%}
{% endgcloak %}







{%comment%}
/the-space-component.html#TheSpaceComponent-PrimaryBackupNotifications
{%endcomment%}


