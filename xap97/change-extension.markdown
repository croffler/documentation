---
layout: post
title:  Change Extension
categories: XAP97
parent: change-api.html
weight: 200
---

{% summary %}This page covers the Change API, its usage and behavior.{% endsummary %}


# Overview

The `ChangeExtension` provides utility methods on top of the [Change API](./change-api.html) that simplify the common use cases of the `change` operation.

# Add and Get operation

A common usage pattern is to increment a numeric property of a specific entry and needing the updated value after the increment was applied.
Using the `addAndGet` operation you can do that using one method call and get an atomic add and get operation semantics.
Following is an example of incrementing a property named `counter` inside an entry of type `WordCount`:

{% highlight java %}
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id, routing);
Integer newCounter = ChangeExtension.addAndGet(space, idQuery, "counter", 1);
{% endhighlight %}

You should use the primitive wrapper types as the operation semantic is to return null if there is no object matching the provided id query

{% info %}You can use `import static org.openspaces.extensions.ChangeExtension.` in order to remove the need to prefix the call with `ChangeExtension'.{% endinfo %}
