---
layout: post
title:  JMS API Basic Usage
categories: XAP97
parent: jms---basics.html
weight: 100
---

{% compositionsetup %}
{% summary %}Basic JMS API Usage{% endsummary %}

# Basic JMS Workflow

1. Obtain/create a `ConnectionFactory` instance.
1. Create a `Connection` with the `ConnectionFactory`.
1. Create a `Session` with the `Connection`.
1. Obtain/create a `Destination` (`Topic` or `Queue`).
1. Message production:
    1. Create `MessageProducers` with the `Session` and the destination.
    1. Create a `Message` with the `Session`.
    1. Send the `Message` with the `MessageProducer`.

1. Message Consumption:
    1. Create `MessageConsumers` with the `Session` and the destination.
    1. Enable connection message consumption by calling the `Connection.start()` method.
    1. For synchronous consumption, call the `MessageConsumer.receive()` method.
    1. For asynchronous consumption, set the `MessageConsumer` `MessageListener`, and implement the `onMessage()` method.

1. When the application finishes, release all resources by closing the connection.

# Using Unified Messaging Model (JMS 1.1)

{% togglecloak id=X %}{% color #6999cb %}**Click to see the code example:**{% endcolor %}{% endtogglecloak %}
{% gcloak X %}
{% panel bgColor=white|borderStyle=none %}

{% highlight java %}
ConnectionFactory connectionFactory = // obtain
Connection connection = connectionFactory.createConnection();
Session session = connection.createSession(false, Session.AUTO_ACKNOWLEDGE);
Queue destination = // obtain (the destination can also be a Topic)

// producer code
MessageProducer producer = session.createProducer(destination);
Message msg = session.createMessage();
for (...) {
	producer.send(msg);
}

// consumer code

// synchronous consumer code
MessageConsumer consumer = session.createConsumer(destination);
for (...) {
	Message msg = consumer.receive();
	...
}

// asynchronous consumer code
MessageConsumer consumer = session.createConsumer(destination);
consumer.setMessageListener(new MessageListener() {
	public void onMessage(Message msg) {
		...
	}
});

// start the connection to receive messages
connection.start();

// release resources
connection.close();
{% endhighlight %}

{% endpanel %}
{% endgcloak %}

# Using Separate Domains (JMS 1.0.2)

## Publish/Subscribe

{% togglecloak id=y %}{% color #6999cb %}**Click to see the code example:**{% endcolor %}{% endtogglecloak %}
{% gcloak y %}
{% panel bgColor=white|borderStyle=none %}

{% highlight java %}
TopicConnectionFactory topicConnectionFactory = // obtain
TopicConnection topicConnection = topicConnectionFactory.createTopicConnection();
TopicSession topicSession = topicConnection.createTopicSession
(false, Session.AUTO_ACKNOWLEDGE);
Topic destination = // obtain

// producer code
TopicPublisher publisher = topicSession.createPublisher();
Message msg = topicSession.createMessage();
for (...) {
	publisher.send(msg);
}

// consumer code

// synchronous consumer code
TopicSubscriber subscriber = topicSession.createSubscriber(destination);
for (...) {
	Message msg = subscriber.receive();
	...
}

// asynchronous consumer code
TopicSubscriber subscriber = topicSession.createSubscriber(destination);
subscriber.setMessageListener(new MessageListener() {
	public void onMessage(Message msg) {
		...
	}
});

// start the connection to receive messages
topicConnection.start();

// release resources
topicConnection.close();
{% endhighlight %}

{% endpanel %}
{% endgcloak %}

## Point to Point

{% togglecloak id=z %}{% color #6999cb %}**Click to see the code example:**{% endcolor %}{% endtogglecloak %}
{% gcloak z %}
{% panel bgColor=white|borderStyle=none %}

{% highlight java %}
QueueConnectionFactory queueConnectionFactory = // obtain
QueueConnection queueConnection = queueConnectionFactory.createQueueConnection();
QueueSession queueSession = queueConnection.createQueueSession
(false, Session.AUTO_ACKNOWLEDGE);
Queue destination = // obtain

// producer code
QueueSender sender = queueSession.createSender(destination);
Message msg = qSession.createMessage();
for (...) {
	sender.send(msg);
}

// consumer code

// synchronous consumer code
QueueReceiver receiver = queueSession.createReceiver(destination);
for (...) {
	Message msg = receiver.receive();
	...
}

// asynchronous consumer code
QueueReceiver receiver = queueSession.createReceiver(destination);
receiver.setMessageListener(new MessageListener() {
	public void onMessage(Message msg) {
		...
	}
});

// start the connection to receive messages
queueConnection.start();

// release resources
queueConnection.close();
{% endhighlight %}

{% endpanel %}
{% endgcloak %}
