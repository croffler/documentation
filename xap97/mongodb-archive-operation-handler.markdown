---
layout: post
title:  Archive Handler
categories: XAP97
parent: mongodb.html
weight: 200
---

{% summary page|60 %}Archives space objects to MongoDB.{% endsummary %}


{%section%}
{%column width=60% %}
# Overview

The [Archive Container](./archive-container.html) can be configured to work against MongoDB (without writing any extra code). The [ArchiveOperationHandler interface](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/archive/ArchiveOperationHandler.html) abstracts the Big-Data storage from the [Archive Container](./archive-container.html). The MongoDB Archive Operation Handler implements this interface by serializing space objects into MongoDB.
{%endcolumn%}
{%column width=35% %}

![archive-container-mongodb.jpg](/attachment_files/archive-container-mongodb.jpg)
{%endcolumn%}
{%endsection%}

# Configuration

## Library dependencies

The MongoDB Archive Operation Handler uses the [MongoDB driver](http://www.allanbank.com/mongodb-async-driver/index.html) for communicating with the MongoDB cluster.
Include the following in your `pom.xml`


{% highlight xml %}
<dependency>
	<groupId>org.mongodb</groupId>
	<artifactId>mongo-java-driver</artifactId>
	<version>2.11.2</version>
</dependency>

<dependency>
	<groupId>com.allanbank</groupId>
	<artifactId>mongodb-async-driver</artifactId>
	<version>1.2.3</version>
</dependency>

<dependency>
	<groupId>org.antlr</groupId>
	<artifactId>antlr4-runtime</artifactId>
	<version>4.0</version>
</dependency>

<dependency>
	<groupId>commons-pool</groupId>
	<artifactId>commons-pool</artifactId>
	<version>1.4</version>
</dependency>
{% endhighlight %}



## Setup

{% inittab os_simple_space|top %}

{%comment%}
{% tabcontent Namespace %}

{% highlight xml %}

<os-archive:mongo-archive-handler id="mongoArchiveHandler" 
	giga-space="gigaSpace" 
	config-ref="config" 
	db="${mongodb.db}"/>
{% endhighlight %}

{% endtabcontent %}

{%endcomment%}

{% tabcontent Plain XML %}

{% highlight xml %}

<bean id="mongoArchiveHandler" class="com.gigaspaces.persistency.archive.MongoArchiveOperationHandler">
	<property name="gigaSpace" ref="gigaSpace" />
	<property name="config" ref="config" />
	<property name="db" value="${mongodb.db}" />
</bean>
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Code %}

{% highlight java %}

ArchiveOperationHandler cassandraArchiveHandler =
	new MongoArchiveOperationHandlerConfigurer()
	 .gigaSpace(gigaSpace)
	 .config(config)
	 .db("mydb")
	 .create();

// To free the resources used by the archive container make sure you close it properly.
// A good life cycle event to place the destroy() call would be within the @PreDestroy or DisposableBean#destroy() method.

archiveContainer.destroy();
{% endhighlight %}

{% endtabcontent %}
{% endinittab %}

## `MongoArchiveOperationHandler` Properties

{: .table .table-bordered}
|Property|Description|
|:-------|:----------|
|gigaSpace| GigaSpace reference used for type descriptors. see [Archive Container](./archive-container.html#Configuration)|
|config | MongoClientConfiguration reference used to handle the mongodb driver configuration. see [MongoClientConfiguration](http://www.allanbank.com/mongodb-async-driver/apidocs/com/allanbank/mongodb/MongoClientConfiguration.html)|
|db | mongodb database name|


{%comment%}
## XSD Schema

- <os-archive:mongo-archive-handler> schema:

{% indent %}
![mongodb-archive-handler-schema-9-7-0.png](/attachment_files/mongodb-archive-handler-schema-9-7-0.png)
{% endindent %}
 {%endcomment%}