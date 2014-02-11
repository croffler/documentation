---
layout: post
title:  Data Event Listener
categories: XAP97
parent: event-processing.html
weight: 400
---

{% compositionsetup %}
{% summary page|60 %}Describe the common Space Data Event Listener and its different adapters.{% endsummary %}

# Overview

{%section%}
{%column width=70% %}
OpenSpaces provides a single interface for Space Data event listeners used by different event containers (Space data event generators) such as Polling Event and Notify Event containers. The benefit of doing so is the loose coupling between how the events are received (the different containers) and what to do with a received event (the listener).
{%endcolumn%}
{%column width=25% %}
![data_event.jpg](/attachment_files/data_event.jpg)
{%endcolumn%}
{%endsection%}

# Space Data Event Listener

At their core, all different event containers should support raising event to an implementation of `SpaceDataEventContainer`. It is a simple interface described below:

{% highlight java %}
public interface SpaceDataEventListener {
    /**
     * An event callback with the actual data object of the event.
     *
     * @param data
     *            The actual data object of the event
     * @param gigaSpace
     *            A GigaSpace instance that can be used to perofrm additional operations against the
     *            space
     * @param txStatus
     *            An optional transaction status allowing to rollback a transaction programatically
     * @param source
     *            Optional additional data or the actual source event data object (where relevant)
     */
    void onEvent(Object data, GigaSpace gigaSpace, TransactionStatus txStatus, Object source);
}
{% endhighlight %}

If we take the following simple implementation of the event listener interface:

{% highlight java %}
public class SimpleListener implements SpaceDataEventListener {

    public void onEvent(Object data, GigaSpace gigaSpace, TransactionStatus txStatus, Object source) {
        // process event
    }
}
{% endhighlight %}

Here is how it can be configured:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<os-events:x-container ...>
    <!-- ... -->

    <os-events:listener ref="simpleListener" />
</os-events>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<bean id="eventContainer" class="...">
    <!-- ... -->

    <property name="eventListener" ref="simpleListener" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# POJO Event Listener Adapters

OpenSpaces comes with two built in event adapters, the first supporting annotations and the second supporting method listing. Here is a simple example of an event listener implementation using annotations:

{% highlight java %}
public class SimpleListener {

    @SpaceDataEvent
    public void myEventHandler(Object data) {
        // process event
    }
}
{% endhighlight %}

The `myEventHandler` is marked using the `SpaceDataEvent` annotation as a callback that needs to be called in case of an event. Here is the XML configuration of the mentioned event listener:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<os-events:x-container ...>
    <!-- ... -->

    <os-events:listener>
        <os-events:annotation-adapter>
            <os-events:delegate ref="simpleListener"/>
        </os-events:annotation-adapter>
    </os-events:listener>
</os-events>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<bean id="eventContainer" class="...">
    <!-- ... -->

    <property name="eventListener">
    	<bean class="org.openspaces.events.adapter.AnnotationEventListenerAdapter">
    	    <property name="delegate" ref="simpleListener" />
    	</bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

If we do not wish to use annotations, we can use the method adapter where method listing is used to define which methods are to be invoked. We can reuse the same SimpleListener (simply without the annotation) and configure it in the following manner:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<os-events:x-container ...>
    <!-- ... -->

    <os-events:listener>
        <os-events:method-adapter method-name="myEventHandler">
            <os-events:delegate ref="simpleListener"/>
        </os-events:method-adapter>
    </os-events:listener>
</os-events>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<bean id="eventContainer" class="...">
    <!-- ... -->

    <property name="eventListener">
    	<bean class="org.openspaces.events.adapter.MethodEventListenerAdapter">
    	    <property name="methodName" value="myEventHandler" />
    	    <property name="delegate" ref="simpleListener" />
    	</bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## Adapter Method Parameter's

The adapter method callback can accept zero or more parameters following the same order and types of the `SpaceDataEventListener`. Since the different adapters use reflection to invoke the event method, specific types can be used as the data event (based on the template provided to the event container). For example, if we define a template that matches `Trade` objects, our listener can use it directly:

{% highlight java %}
public class SimpleListener {

    @SpaceDataEvent
    public void myEventHandler(Trade trade, GigaSpace gigaSpace) {
        // process event
    }
}
{% endhighlight %}

## Adapter Method Return Value

The adapter method callback can have a return value which will automatically be written back to the Space. The return value can either be a single object (which will cause write to be called) or an array of objects (which will cause writeMultiple to be called).

By default, an update-or-write operation will be performed. This flag can be set to `false` which will force a write operation to be performed. Update timeout and write lease can also be configured.

Here is an example of an event listener that returns an array of `Order` as a result of a `Trade`:

{% highlight java %}
public class SimpleListener {

    @SpaceDataEvent
    public Order[] processTrade(Trade trade, GigaSpace gigaSpace) {
        // process event
    }
}
{% endhighlight %}

and the following is the configuration of such a listener using the annotation adapter:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<os-events:x-container ...>
    <!-- ... -->

    <os-events:listener>
        <os-events:annotation-adapter update-or-write="false" update-timeout="1000" write-lease="1000">
            <os-events:delegate ref="simpleListener"/>
        </os-events:annotation-adapter>
    </os-events:listener>
</os-events>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<bean id="eventContainer" class="...">
    <!-- ... -->

    <property name="eventListener">
    	<bean class="org.openspaces.events.adapter.AnnotationEventListenerAdapter">
    	    <property name="delegate" ref="simpleListener" />
    	    <property name="writeLease" value="1000" />
    	    <property name="updateTimeout" value="1000" />
    	</bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## Multiple Event Methods

A single class can have several method event listeners all with the same name. This allows for automatic matching based on the data event type. Here is an example using annotations:

{% highlight java %}
public class SimpleListener {

    @SpaceDataEvent
    public void processTrade(Trade trade, GigaSpace gigaSpace) {
        // process event
    }

    @SpaceDataEvent
    public void processTrade(SpecialTrade trade, GigaSpace gigaSpace) {
        // process event
    }
}
{% endhighlight %}

{% tip %}
When using a single event method, the event adapter will cache the reflection information in order to invoke the method. In case multiple methods are used, no caching of the reflection information can be done, so a slight performance impact can be experienced.
{% endtip %}

# Task Executor Event Listener Adapter

OpenSpaces comes with an event adapter that allows you to delegate the execution of an event listener to a different task executor (a thread pool). It is handy when using the notify container and wanting to release the notification thread. Here is how it can be configured:

{% inittab os_simple_space|top %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<os-events:x-container ...>
    <!-- ... -->

    <os-events:listener>
        <bean class="org.openspaces.events.adapter.TaskExecutorEventListenerAdapter">
            <property name="delegate">
                <os-events:annotation-adapter update-or-write="false" update-timeout="1000" write-lease="1000">
                    <os-events:delegate ref="simpleListener"/>
                </os-events:annotation-adapter>
            </property>
        </bean>
    </os-events:listener>
</os-events>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleListener" class="SimpleListener" />

<bean id="eventContainer" class="...">
    <!-- ... -->

    <property name="eventListener">
        <bean class="org.openspaces.events.adapter.TaskExecutorEventListenerAdapter">
            <property name="delegate">
                <bean class="org.openspaces.events.adapter.AnnotationEventListenerAdapter">
                    <property name="delegate" ref="simpleListener" />
                    <property name="writeLease" value="1000" />
                    <property name="updateTimeout" value="1000" />
                </bean>
            </property>
    	</bean>
    </property>
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

The default task executor uses Spring's `SimpleAsyncTaskExecutor` which creates a thread for each execution. Other [Task Executors](http://docs.spring.io/spring/docs/2.0.x/reference/scheduling.html) can be used by setting it on the `taskExecutor` property.
