---
layout: post
title:  Counters
categories: XAP97
parent: the-gigaspace-interface.html
weight: 200
---

{% compositionsetup %}

{% section %}
{% column %}
{% summary page|60 %}Real Time atomic counter using the `GigaSpace.change` API{% endsummary %}
{% endcolumn %}
{% column %}
![counter-logo.jpg](/attachment_files/counter-logo.jpg)
{% endcolumn %}
{% endsection %}

# Overview

A growing number of applications such as real time ad impressions , ad optimization engines, social network , on-line gaming , need real-time counters when processing incoming streaming of events. The challenge is to update the counter in atomic manner without introducing a bottleneck event processing flow. GigaSpaces introducing Counter functionality via the `GigaSpace.change` API. It allow you to increment or decrement an Numerical field within your Space object (POJO or Document). This change may operate on a numeric property only (byte,short,int,long,float,double) or their corresponding Boxed variation. To maintain a counter you should use the Change operation with the `ChangeSet` increment/decrement method that adds/subtract the provided numeric value to the existing counter. There is no need to use a transaction when getting the counter value as the counter is atomic.

![change-api-counter.jpg](/attachment_files/change-api-counter.jpg)

If the counter property does not exists, the delta will be set as its initial state. This simple API allows you to maintain counters with minimal impact on the system performance as it is replicating only the `ChangeSet` command and not the entire space object to the backup copy when running a clustered data-grid.

# Incrementing a Counter

Incrementing a Counter done using the `ChangeSet().increment` call:

{% highlight java %}
GigaSpace space = // ... obtain a space reference
String id = "myID";
IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id);
space.change(idQuery, new ChangeSet().increment("mycounter", 1));
{% endhighlight %}

# Decrementing a Counter

Decrementing a Counter done using the `ChangeSet().decrement` call:

{% highlight java %}
GigaSpace space = // ... obtain a space reference
String id = "myID";
IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id);
space.change(idQuery, new ChangeSet().decrement("mycounter", 1));
{% endhighlight %}

# Clearing a Counter

Clearing the Counter value done using the `ChangeSet().unset` call:

{% highlight java %}
GigaSpace space = // ... obtain a space reference
String id = "myID";
IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id);
space.change(idQuery, new ChangeSet().unset("mycounter"));
{% endhighlight %}

# Getting the Counter value

Getting the Counter value done via the read call:

{% highlight java %}
GigaSpace space = // ... obtain a space reference
String id = "myID";
IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id);
WordCount wordount = space.readById(WordCount.class , idQuery);
int counterValue = wordount.getMycounter();
{% endhighlight %}

Another way geting the Counter value without reading the space object back to the client would be via a [Task](./task-execution-over-the-space.html):

{% highlight java %}
public class GetCounterTask implements Task<Integer> {

	String id ;

	public GetCounterTask (string id) {
		this.id= id;
	}

  	@TaskGigaSpace
  	private transient GigaSpace space;

  	public Integer execute() throws Exception {
		IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id);
		WordCount wordount = space.readById(WordCount.class , idQuery);
		return wordount.getMycounter();
  }
}
{% endhighlight %}

Call the execute method to fetch the current Counter value:

{% highlight java %}
AsyncFuture<Integer> future = gigaSpace.execute(new GetCounterTask("myID"), routingValue);
int counterValue= future.get();
{% endhighlight %}

# Pre-Loading Counters

When pre-loading the space via the [External Data Source initial-load](./space-persistency-initial-load.html) you may need to construct Counters data. The `initialLoad` method allows you to implement the logic to generate the counter data and load it into the space after the actual data been loaded from the external data source (database).

# Example

With the following example the `Counter` class wraps the `GigaSpace.change` operation providing simple `increment`,`decrement`,`get` and `unset` methods to manage counters. The example using an [extended SpaceDocument](./extending-space-documents.html) as the space object storing the counters data. To retrieve the counter existing value a [Task](./task-execution-over-the-space.html) is used. To launch the example run the `CounterTest` unit test.

{% highlight java %}
package org.openspaces;
import org.junit.Before;
import org.junit.Test;
import org.openspaces.core.GigaSpace;
import org.openspaces.core.GigaSpaceConfigurer;
import org.openspaces.core.space.UrlSpaceConfigurer;
import static org.junit.Assert.*;

public class CounterTest {

	static GigaSpace space = null;
	static GigaSpace spaceEmb = null;
	static Counter counter = null;

	@Before
	public void setUp() throws Exception {
		if (space == null)
		{
			spaceEmb= new GigaSpaceConfigurer(new UrlSpaceConfigurer("/./mySpace")).gigaSpace();
			space = new GigaSpaceConfigurer(new UrlSpaceConfigurer("jini://*/*/mySpace")).gigaSpace();
			space.clear(null);
			counter = new Counter(space, "id", "counter1", 10);
		}
	}

	@Test
	public void test1() throws Exception
	{
		counter.increment("counter1", 1);
		int counterValue = counter.get("counter1");
		System.out.println("test increment - Counter Value:" + counterValue + " - should be: 11");
		assertEquals(counterValue , 11);
	}

	@Test
	public void test2() throws Exception
	{
		counter.decrement("counter1", 1);
		int counterValue = counter.get("counter1");
		System.out.println("test decrement - Counter Value:" + counterValue + " - should be: 10");
		assertEquals(counterValue , 10);
	}


	@Test
	public void test3() throws Exception
	{
		counter.unset("counter1");
		Integer counterValue = counter.get("counter1");
		System.out.println("test unset - Counter Value:" + counterValue + " - should be: null");
		assertEquals(counterValue , null);
	}
}
{% endhighlight %}

{% highlight java %}
package org.openspaces;

import org.openspaces.core.GigaSpace;

import com.gigaspaces.async.AsyncFuture;
import com.gigaspaces.client.ChangeSet;
import com.gigaspaces.query.IdQuery;

public class Counter {

	GigaSpace space = null;
	String id = null;

	public Counter (GigaSpace space , String id , String name , int initialValue)
	{
		this.space = space;
		this.id = id;
		CounterData.registerType(space);
		CounterData counterData = new CounterData();
		counterData.setProperty(name, initialValue);
		counterData.setProperty("id", id);
		space.write(counterData);
	}

	public Integer get(String name) throws Exception
	{
		CounterTask task = new CounterTask(id, name);
		AsyncFuture<Integer> res= space.execute(task , id);
		return res.get();
	}

	public void increment(String name , int value)
	{
		IdQuery<CounterData> query= new IdQuery<CounterData> (CounterData.TYPE_NAME , id , id);
		space.change(query,new ChangeSet().increment(name, value));
	}

	public void decrement(String name , int value)
	{
		IdQuery<CounterData> query= new IdQuery<CounterData> (CounterData.TYPE_NAME , id , id);
		space.change(query,new ChangeSet().decrement(name, value));
	}

	public void unset(String name)
	{
		IdQuery<CounterData> query= new IdQuery<CounterData> (CounterData.TYPE_NAME , id , id);
		space.change(query,new ChangeSet().unset(name));
	}
}
{% endhighlight %}

{% highlight java %}
package org.openspaces;

import org.openspaces.core.GigaSpace;

import com.gigaspaces.document.SpaceDocument;
import com.gigaspaces.metadata.SpaceTypeDescriptor;
import com.gigaspaces.metadata.SpaceTypeDescriptorBuilder;
import com.gigaspaces.metadata.index.SpaceIndexType;

public class CounterData extends SpaceDocument{
	   public static final String TYPE_NAME = "CounterData";

	   public CounterData() {
	        super(TYPE_NAME);
	    }

	   static public void registerType(GigaSpace gigaspace) {
		    // Create type descriptor:
		    SpaceTypeDescriptor typeDescriptor =
		        new SpaceTypeDescriptorBuilder(TYPE_NAME)
		        // ... Other type settings
		        .documentWrapperClass(CounterData.class)
		        .addFixedProperty("id", String.class)
		        .idProperty("id" ,false , SpaceIndexType.BASIC)
		        .create();
		    // Register type:
		    gigaspace.getTypeManager().registerTypeDescriptor(typeDescriptor);
		}
}
{% endhighlight %}

{% highlight java %}
package org.openspaces;

import org.openspaces.core.GigaSpace;
import org.openspaces.core.executor.Task;
import org.openspaces.core.executor.TaskGigaSpace;
import com.gigaspaces.query.IdQuery;

public class CounterTask implements Task<Integer> {

	String id ;
	String name ;

	public CounterTask(String id , String name ) {
		this.id= id;
		this.name = name;
	}

  	@TaskGigaSpace
  	private transient GigaSpace space;

  	public Integer execute() throws Exception {
		IdQuery<CounterData> query= new IdQuery<CounterData> (CounterData.TYPE_NAME , id , id);
		CounterData counterData = space.readById(query);
		return counterData.getProperty(name);
  }
}
{% endhighlight %}
