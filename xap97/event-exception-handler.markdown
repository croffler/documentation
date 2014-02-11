---
layout: post
title:  Event Exception Handler
categories: XAP97
parent: event-processing.html
weight: 500
---

{% compositionsetup %}
{% summary page|60 %}Describe the common Exception Event Listener and its different adapters.{% endsummary %}

# Overview

OpenSpaces provides a mechanism allowing to hook into how exception raised by event listeners are handled, specifically when the event listeners are executed under the context of a transaction.

# Event Exception Handler

An event exception handler should implement the following interface:

{% highlight java %}
public interface EventExceptionHandler<T> {

    /**
     * A callback when a successful execution of a listener.
     *
     * @param data      The actual data object of the event
     * @param gigaSpace A GigaSpace instance that can be used to perform additional operations against the
     *                  space
     * @param txStatus  An optional transaction status allowing to rollback a transaction programmatically
     * @param source    Optional additional data or the actual source event data object (where relevant)
     */
    void onSuccess(T data, GigaSpace gigaSpace,
                   TransactionStatus txStatus, Object source) throws RuntimeException;

    /**
     * A callback to handle exception in an event container. The handler can either handle the exception
     * or propagate it.
     *
     * <p>If the event container is transactional, then propagating the exception will cause the transaction to
     * rollback, which handling it will cause the transaction to commit.
     *
     * <p>The TransactionStatus can also be used to control if the transaction
     * should be rolled back without throwing an exception.
     *
     * @param exception The listener thrown exception
     * @param data      The actual data object of the event
     * @param gigaSpace A GigaSpace instance that can be used to perform additional operations against the
     *                  space
     * @param txStatus  An optional transaction status allowing to rollback a transaction programmatically
     * @param source    Optional additional data or the actual source event data object (where relevant)
     */
    void onException(ListenerExecutionFailedException exception, T data,
                     GigaSpace gigaSpace, TransactionStatus txStatus, Object source) throws RuntimeException;
}
{% endhighlight %}

If we take the following simple implementation of the event listener interface:

{% highlight java %}
public class SimpleEventExceptionHandler implements EventExceptionHandler {
    public void onSuccess(T data, GigaSpace gigaSpace,
                          TransactionStatus txStatus, Object source) throws RuntimeException {
        // process success
    }

    public void onException(ListenerExecutionFailedException exception, Object data,
                            GigaSpace gigaSpace, TransactionStatus txStatus, Object source) throws RuntimeException {
        // process failure
    }
}
{% endhighlight %}

Here is how it can be configured:

{% inittab os_simple_space|top %}
{% tabcontent Annotation %}

{% highlight java %}

@EventDriven @Polling
public class SimpleListener {

    @ExceptionHandler
    public EventExceptionHandler exceptionHandler() {
        // can return this is SimpleListener implemented EventExceptionHandler
        return new SimpleEventExceptionHandler();
    }

    @EventTemplate
    Data unprocessedData() {
        Data template = new Data();
        template.setProcessed(false);
        return template;
    }

    @SpaceDataEvent
    public Data eventListener(Data event) {
        //process Data here
    }
}
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Namespace %}

{% highlight xml %}

<bean id="simpleExceptionHandler" class="SimpleEventExceptionHandler" />

<os-events:x-container ...>
    <!-- ... -->

    <os-events:exception-handler ref="simpleExceptionHandler" />
</os-events>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="simpleExceptionHandler" class="SimpleEventExceptionHandler" />

<bean id="eventContainer" class="...">
    <!-- ... -->

    <property name="exceptionHandler" ref="simpleExceptionHandler" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

# Using the Event Exception Handler

One of the main use cases that an Exception Handler can be used for is to filter out poison messages. For example, with a polling container, if the event data (the message) can't be processed, and the polling container is transactional, it will continue to retry the message indefinitely. It will start a transaction, perform a take, try and process the message, throwing an exception in the process, and rolling back the transaction causing the take operation to be rolled back.

If the type of the exception is know to be unrecoverable, an exception handler can be registered that will check the exception type (the cause of the ListenerExecutionFailedException), detect it, and not re-throw an exception, but instead write that entry wrapped in a "Poison Message" entry back into the space creating a dead letter queue that can be processed later on.

A retry counter can also be handled by creating a generic interface, for example called `RetryMessageEntry`, which certain messages will implement. That interface will allow to increment a counter and reset it. The counter field will be part of the entry (i.e. persisted in the space).

When an exception occurs, the retry counter will be incremented. If its under a specific threshold, the data object will be rewritten back to the space with the incremented counter (causing it to be taken again by the polling container). No exception will be raised in this case, as we want the transaction to be committed with the updated counter. Another option is to write a new entry with an updated counter, if there might have been side affects to the listener that the transaction should not commit.

If the threshold has been breached, the same poising message handling described above can be applied.

Its important to note that the exception handler `onException` and `onSuccess` operate under the existing on going transaction started by the polling container. Doing something outside of a transaction can be done by using a `GigaSpace` instance that is not associated with a transaction manager.
