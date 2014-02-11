---
layout: post
title:  Working with GSJMSAdmin
categories: XAP97
parent: jms-administration-api.html
weight: 200
---

{% summary page|60 %}Obtaining JMS resources without JNDI, Using JNDI with GSJMSAdmin.{% endsummary %}

# Overview

The `GSJMSAdmin` class is offered by GigaSpaces to simplify the obtaining of JMS resources. You can use this class to work with or without JNDI.

# Obtaining Resources with GSJMSAdmin without Using JNDI

The following methods create connection factories to work against a space specified as a URL or a proxy.

`GSJMSAdmin` caches the created factories, so the same factory is returned for multiple invocation of methods to the same space.

{% highlight java %}
ConnectionFactory getConnectionFactory(String spaceURL)
ConnectionFactory getConnectionFactory(IJSpace space)
QueueConnectionFactory getQueueConnectionFactory(String spaceURL)
QueueConnectionFactory getQueueConnectionFactory(IJSpace space)
TopicConnectionFactory getTopicConnectionFactory(String spaceURL)
TopicConnectionFactory getTopicConnectionFactory(IJSpace space)
{% endhighlight %}

For example, to get a connection factory to `mySpace`:

{% highlight java %}
GSJMSAdmin admin = GSJMSAdmin.getInstance();
String url="rmi://myhost:myport/mySpace_container/mySpace;jini://myhost/./mySpace";
ConnectionFactory factory = admin.getConnectionfactory(url); // or a proxy
{% endhighlight %}

{% exclamation %} Using the following space URL:

    rmi://myhost:myport/myJMSSpace_container/myJMSSpace;jini://myhost/./myJMSSpace

combines two separate Lookup Services: a Jini Lookup Service and the JNDI-based `RMIRegistry`, avoiding **Single Point of Failure**.

The following methods return a cached instance of a destination, or a new instance if no instance exists.

{% highlight java %}
Queue getQueue(String name)
Topic getTopic(String name)
{% endhighlight %}

For example, to get the Topic `myTopic`:

{% highlight java %}
GSJMSAdmin admin = GSJMSAdmin.getInstance();
Topic topic = admin.getTopic(myTopic);
{% endhighlight %}

# Obtaining Resources with GSJMSAdmin Using JNDI

You can use `GSJMSAdmin` to look up JMS resources in JNDI.

{% highlight java %}
Object jndiLookup(String name)
{% endhighlight %}

For example, to obtain the Topic `MyTopic`:

{% highlight java %}
GSJMSAdmin admin = GSJMSAdmin.getInstance();
Topic topic = admin.jndiLookup("GigaSpaces;ContainerName;spaceName;jms;destinations;MyTopic")
{% endhighlight %}

{% infosign %} The name used to look for the resource is the full binding name.
