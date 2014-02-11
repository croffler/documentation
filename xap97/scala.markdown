---
layout: post
title:  Scala
categories: XAP97
parent: interoperability.html
weight: 300
---


{% section %}
{% column %}
{% summary page|65 %}XAP Scala integration.{% endsummary %}
{% endcolumn %}
{% column %}
![scala-logo.jpg](/attachment_files/scala-logo.jpg)
{% endcolumn %}
{% endsection %}

{% info %}
The minimum Scala version required in order to use the Scala Openspaces extension is 2.10
{% endinfo %}

# Overview

Several extensions to OpenSpaces API have been introduced to provide a more natural way of combining Scala with XAP.

# General Setup

Assuming there is a scala installation under `$SCALA_HOME`, the jars under `$SCALA_HOME/lib` should be copied to `$GS_HOME/lib/platform/scala/lib`.
Another options is to change `setenv.{bat,sh`} so that `$SCALA_JARS` points to `$SCALA_HOME/lib`.

{% children %}
