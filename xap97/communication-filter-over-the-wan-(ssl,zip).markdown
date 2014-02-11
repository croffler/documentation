---
layout: post
title:  Communication Filter Over the Wan (SSL,ZIP)
categories: XAP97
parent: multi-site-replication-over-the-wan.html
weight: 100
---

{% summary %}This page is about putting filters over the network communication which goes across the WAN.{% endsummary %}

{% info %}
This page assume prior knowledge of multi-site replication, please refer to [Multi-Site Replication (WAN)](./multi-site-replication-over-the-wan.html) before reading this page.
{% endinfo %}

# Overview

Filtering network communication across the WAN are done for two main reasons:

1. Compressing the network traffic between the sites.
1. Securing the network using SSL in case the communication between the sites is going over open WAN (not via VPN or other underlying encryption mechanisms).

For both cases there are two built-in [LRMI](./communication-protocol.html) [Filters](./securing-the-transport-layer-(using-ssl).html).

# Selecting the Filter

For compression the `com.gigaspaces.lrmi.nio.filters.IOStreamCompressionFilterFactory` should be used and for encryption `com.gigaspaces.lrmi.nio.filters.SSLFilterFactory` should be used.
In both cases, you need to specify to which remote addresses this filter should be used, this is done be creating a config file which describes these addresses, putting it in the class path of the GSC (usually could be under `<XAP Install>/config` directory and pointing to it with a system property.

# Address Matcher File Format

Each line in the file represents a regular expression which will be applied on the remote address when a connection is established. If any of the regular expressions in the file matches that address, the filter will be created on this communication channel.

For example, if you have three sites and you want to compress the communication only between these sites, you should have an address matcher file configured to point to
the address of the other. It could be named "address-matcher.config", placed under `<XAP Install>/config` of the gateway hosting machine.
It should contain a line with a regular expression matching the remote sites gateway hosting machine address, lets assume its hostname is Site-A.
The address matcher should look like this:

{% highlight java %}
.*Site-A.*
{% endhighlight %}

And on Site-A the address matcher file should look like this:

{% highlight java %}
.*Site-B.*
{% endhighlight %}

This file can contain more than one line and can be commented using the # char at the beginning of the line.

# Configuring the Gateway GSC

If you are starting your own GSC that will host the gateway processing unit, you should start it with the following system properties:

{% highlight java %}
-Dcom.gs.lrmi.filter.factory=<filter name>
-Dcom.gs.lrmi.filter.address-matchers-file=config/<file name>
{% endhighlight %}

If you use the built in mechanism which spawns a GSC to host the gateway you can specify custom jvm properties to be used when spawning the GSC either on the sink or delegator component (but only one of them):

{% highlight xml %}
<os-gateway:sink id="sink"  ...
  custom-jvm-properties="-Dcom.gs.lrmi.filter.factory=<filter name> -Dcom.gs.lrmi.filter.address-matchers-file=config/<file name>" />

or

<os-gateway:delegator id="delegator" ...
  custom-jvm-properties="-Dcom.gs.lrmi.filter.factory=<filter name> -Dcom.gs.lrmi.filter.address-matchers-file=config/<file name>" />
{% endhighlight %}

{% info %}
e.g. -Dcom.gs.lrmi.filter.factory=com.gigaspaces.lrmi.nio.filters.IOStreamCompressionFilterFactory
{% endinfo %}
