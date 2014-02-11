---
layout: post
title:  Notifications
categories: XAP97
parent: the-space.html
weight: 3500
---

{% summary %}Space operation notifications {% endsummary %}


# Overview
Some of the space operations can generate notifications when they are executed. A listener can be defined to receive these notifications.

The following operations create notifications:

- write, writeMultiple

- take, takeMultiple

- change, changeMultiple


## Notify Example

In the following example we register a listener to receive notifications when an Employee instance is written or update in the space:

{% highlight java %}
@EventDriven
@Notify
@NotifyType(write = true, update = true)
@TransactionalEvent
public class EmployeeListener {
	@EventTemplate
	Employee unprocessedData() {
		Employee template = new Employee();
		template.setStatus("new");
		return template;
	}

	@SpaceDataEvent
	public Employee eventListener(Empoyee event) {
		// process Employee
		System.out.println("Notifier Received an Employee");
		return null;
	}
}
// Register the listener
SimpleNotifyEventListenerContainer eventListener  = new SimpleNotifyContainerConfigurer(
		space).eventListenerAnnotation(new EmployeeListener())
		.notifyContainer();
eventListener.start();

//.......
eventListener.destroy();

{% endhighlight %}

{%learn%}./notify-container.html{%endlearn%}

## Polling Example

In this example we define a notification

{% highlight java %}

  @EventDriven
  @Polling
  @NotifyType(write = true, update = true)
  @TransactionalEvent
  public class EmployeeListener {
	    @EventTemplate
	    Employee unprocessedData() {
	    	Employee template = new Employee();
	    	template.setStatus("new");
		    return template;
	    }

	  @SpaceDataEvent
	  public Employee eventListener(Empoyee event) {
		// process Employee
		System.out.println("Notifier Received an Employee");
		return null;
	 }
  }
  // Register the listener
  SimplePollingEventListenerContainer pollingListener = new SimplePollingContainerConfigurer(
			space).template(new Employee())
			.eventListenerAnnotation(new Object() {
				@SpaceDataEvent
				public void eventHappened(Object event) {
					System.out.println("onEvent called Got" + event);
				}
			}).pollingContainer();

  pollingListener.start();

  //.......
  pollingListener.destroy();
{% endhighlight %}

{%learn%}./polling-container.html{%endlearn%}

