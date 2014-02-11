---
layout: post
title:  Space Container Configuration JMS Tab - GigaSpaces Browser
categories: XAP97
parent: managing-space-containers---gigaspaces-browser.html
weight: 300
---

{% summary %}Enabling JMS, enabling internal JNDI, enabling external JNDI.{% endsummary %}

# Overview

**The JMS tab in the container configuration window enables viewing or modifying of the following container attributes:**

- **JMS Enabled** -- Must be checked in order to configure the server-side of the GigaSpaces JMS interface.
- **Internal JNDI Enabled** -- Must be checked if you want to use the GigaSpaces Server's lookup service for the JMS Destinations and connection factories lookup.
- **External JNDI Enabled** -- Must be checked if you want to use an external lookup service, such as the Jboss JNP naming protocol implementation.
    - If you enabled an external JNDI registry, update your JNDI provider's configuration properties inside the `jndi.properties` file and add the directory that contains the file to your classpath.

![Container Configuration JMS Tab - GigaSpaces Browser.jpg](/attachment_files/Container Configuration JMS Tab - GigaSpaces Browser.jpg)
