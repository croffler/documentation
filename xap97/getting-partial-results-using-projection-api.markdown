---
layout: post
title:  Partial Results
categories: XAP97
parent: querying-the-space.html
weight: 800
---

{% summary %}This page describes how you can obtain partial results when querying the space to improve application performance and reduce memory footprint.{% endsummary %}

# Overview

{% section %}
{% column width=40 %}
In some cases when querying the space for objects, only specific properties of that objects are required and not the entire object (delta read). The same scenario is also relevant when subscribing for notifications on space data changes, where only specific properties are of interest to the subscriber. For that purpose the Projection API can be used where one can specify which properties are of interest and the space will only populate these properties with the actual data when the result is returned back to the user. This approach reduces network overhead , garbage memory generation and serialization CPU overhead.
{% endcolumn %}
{% column %}
![space-projections.jpg](/attachment_files/space-projections.jpg)
{% endcolumn %}
{% endsection %}



# Specifying a Projection with your Query

Projection supported using a [SQLQuery](./sqlquery.html) or [Id Queries](./id-queries.html). Below a simple example reading a `Person` object where only the 'firstName' and 'lastName' properties are returned with the query result array. All other `Person` properties will not be returned:

{% highlight java %}
public class Person
{
  ...
  @SpaceId(autoGenerate = false)
  public Long getId() { ... }
  public String getFirstName() { ... }
  public String getLastName() { ... }
  public String getAddress() { ... }
  ...
}

GigaSpace gigaSpace = //... obtain a gigaspace reference.
Long id = //... obtain the space object ID.
Person result = gigaSpace.read<Person>(new IdQuery<Person>(Person.class, id).setProjections("firstName", "lastName"));
{% endhighlight %}

With the above example a specific Person is being read but only its 'firstName' and 'lastName' will contains values and all the other properties will contain a `null` value.

You may use the same approach with the `SQLQuery` or `IdsQuery`:

{% highlight java %}
SQLQuery<Person> query = new SQLQuery<Person>(Person.class,"").
		setProjections("firstName", "lastName");
Person result[] = gigaSpace.readMultiple(query);

IdsQuery<Person> idsQuery = new IdsQuery<Person>(Person.class, new Long[]{id1,id2}).
		setProjections("firstName", "lastName");
Person result[] = space.readByIds(idsQuery).getResultsArray();
{% endhighlight %}

The [SpaceDocument](./document-api.html) support projections as well:

{% highlight java %}
SQLQuery<SpaceDocument> docQuery = new SQLQuery<SpaceDocument>(Person.class.getName() ,"",
	QueryResultType.DOCUMENT).setProjections("firstName", "lastName");
SpaceDocument docresult[] = gigaSpace.readMultiple(docQuery);
{% endhighlight %}

# Supported Operations

The projection is defined for any operation that return data from the space. Therefore ID Based or Query based operations supporting projections. You can use with `read`,`take`,`readById`,`takeById`,`readMultiple` and `takeMultiple` operations. When performing a `take` operation with projection the entire object will be removed from the space, but the result returned to the user will contain only the projected properties.


You can use projections with the [Notify Container](./notify-container.html) when subscribing to notifications, or with the [Polling Container](./polling-container.html) when consuming space objects. You can also create a [Local View](./local-view.html) with templates or a `View` using projections. The local view will maintain the relevant objects, but with the projected data - only with the projected properties.
Projected properties can specify both dynamic or fixed properties and the usage is the same. As a result, when providing a projected property name which is not part of the fixed properties set, it will be treated as a dynamic property. If there is no dynamic property present with that name on an object which is a result of the query - that projection property will be ignored (and no exception will be raised). Please note that a result may contain multiple objects, each with different set of properties (fixed and dynamic), each object will be treated individually when applying the projections on it.

# Considerations

1. You can't use a projection on [Local Cache](./local-cache.html) as the local cache needs to contain the fully constructed objects, and reconstructing it locally with projection will only impact performance.
1. You can't use a projection to query a Local View for the same reason as Local Cache, however, You can create the local view with projection template and the Local View will be contain the objects in their projected form.


<ul class="pager">
  <li class="previous"><a href="./paging-support-with-space-iterator.html">&larr; Paging Support</a></li>
  <li class="next"><a href="./querying-the-space.html">Querying the Space &rarr;</a></li>
</ul>