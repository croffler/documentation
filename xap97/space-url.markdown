---
layout: post
title:  Space URL
categories: XAP97
parent: the-space-component.html
weight: 400
---

{% summary %}A Space URL is the address of the space, used to create a new space or find an existing one{% endsummary %}

{%comment%}{%javadoc com.j_spaces.core.client.SpaceURL %}{%endcomment%}
{%comment%}[Space Component](./the-space-component.html#SpaceComponent-URLProperties){%endcomment%} 

# Overview

A **Space URL** is a string that represents an address of a space. In short, there are two forms of space URLs:

* **Embedded** (e.g. `/./mySpace`) - Find an embedded (in-process) space called *mySpace*. If it doesn't exist it will be created automatically. 
* **Remote** (e.g. `jini://*/*/mySpace`) - Find a remote space (hosted outside this process) called *mySpace*. If it doesn't exist an exception will be thrown.

The easiest way to create or find a space is to leverage XAP's integration with Spring, as explained in [The Space Component](the-space-component.html).

{%comment%}
If you prefer to use pure code without spring, use the [Configurer API](./programmatic-api-(configurers).html).
{%endcomment%}

# Embedded Space

An **Embedded** space is a space that is hosted in your process. The URL format for locating such a space is:
{% highlight xml %}
/./<spaceName><?key1=val1><&keyN=valN>
{% endhighlight %}

For example, to find an embedded space called `foo` use `/./foo`.

If the requested space does not exist, it is automatically created and returned. If you wish to look for an existing space only, use `create=false` property (e.g. `/./foo?create=false`) - this will throw an exception if the requested space does not exist.

# Remote Space

A **Remote** space is a space that is hosted in a different process. The URL format for locating such a space is:

{% highlight xml %}
jini://<hostName>:<port>/<containerName>/<spaceName><?key1=val1><&keyN=valN>
{% endhighlight %}

For example, to find a remote space called `foo` use `jini://*/*/foo`.

Let's examine that format:

* `jini://` - The prefix indicates to search for the space using the *JINI Lookup Service* protocol.
* `<hostName>:<port>` - Address of the JINI Lookup Service. Use `*` for multicast search, or specify a list of hostnames/ip addresses.   
* `<containerName>` - Indicates a specific member in the cluster to find. Use `*` for finding any cluster member.
* `<spaceName>` - Name of space to find.

{% info %}
For more information regarding unicast and multicast lookup, see [Loouk Service Configuration](./lookup-service-configuration.html).
{%endinfo%}