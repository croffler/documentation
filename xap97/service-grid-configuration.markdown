---
layout: post
title:  Service Grid Configuration
categories: XAP97
parent: the-runtime-environment.html
weight: 300
---


{% summary %}How to configure a Service Grid{% endsummary %}

# Overview

Service Grid configuration is often composed of two layers: system-wide configuration and component-specific configuration.
The system-wide configuration specifies settings which all components share, e.g. discovery (unicast/multicast), security, zones, etc. These are set in the `EXT_JAVA_OPTIONS` environment variable.
The component-specific configuration specifies settings per component type, e.g. the GSC memory limit is greater than the GSM and LUS. These are set in one or more of the following environment variables:

- `GSA_JAVA_OPTIONS`
- `GSC_JAVA_OPTIONS`
- `GSM_JAVA_OPTIONS`
- `LUS_JAVA_OPTIONS`

For example:

{% section %}
{% column width=50% %}
{% highlight java %}
Linux
export GSA_JAVA_OPTIONS=-Xmx256m
export GSC_JAVA_OPTIONS=-Xmx2048m
export GSM_JAVA_OPTIONS=-Xmx1024m
export LUS_JAVA_OPTIONS=-Xmx1024m

. ./gs-agent.sh
{% endhighlight %}
{% endcolumn %}

{% column width=45% %}
{% highlight java %}
Windows
set GSA_JAVA_OPTIONS=-Xmx256m
set GSC_JAVA_OPTIONS=-Xmx2048m
set GSM_JAVA_OPTIONS=-Xmx1024m
set LUS_JAVA_OPTIONS=-Xmx1024m

call gs-agent.bat

{% endhighlight %}
{% endcolumn %}
{% endsection %}

#### Configuring independent components

It is highly recommended that the Service Grid is started (and configured) using the gs-agent as shown above. If you do need to start a specific component separately, you can use the same environment variables shown above.

For example:

{% section %}
{% column width=50% %}
{% highlight java %}
Linux
export GSC_JAVA_OPTIONS=-Xmx1024m

. ./gsc.sh
{% endhighlight %}
{% endcolumn %}
{% column width=45% %}
{% highlight java  %}
Windows
set GSC_JAVA_OPTIONS=-Xmx1024m

call gsc.bat
{% endhighlight %}
{% endcolumn %}
{% endsection %}

{% note %}
Component specific configuration can be set using system properties (follows the \[component name\].\[property name\] notation).
{%endnote%}