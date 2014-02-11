---
layout: post
title:  JMS API Support
categories: XAP97
parent: messaging-support.html
weight: 100
---

{% summary section %}GigaSpaces allows applications to use the space as a messaging hub. Applications use JMS to create topics and queues as usual; these are transparently translated into space Entries.{% endsummary %}

# Overview

GigaSpaces provide a JMS implementation, built on top of the core JavaSpaces layer. JMS messages are implemented as POJO, indexed, and routed to the relevant space partition according to the destination name. GigaSpaces XAP JMS implementation supports the unified messaging model, introduced in version 1.1 of the JMS specification.

# JMS Domains

JMS 1.0.2 specification introduced two domains:

- **Point to Point** -- in this domain, a producer sends messages to a destination of type `Queue`. Each message is consumed by only one consumer.
- **Publish/Subscribe** -- in this domain, a producer publishes messages to a destination of type `Topic`. Any consumer that listens on that `Topic` receives the messages.

In JMS 1.0.2, each domain used a separate set of interfaces. JMS 1.1 presents the **unified model**, that unites the usage of both domains under a single set of interfaces. GigaSpaces XAP JMS implementation supports both the unified model, and the separate domains.

{% children %}
