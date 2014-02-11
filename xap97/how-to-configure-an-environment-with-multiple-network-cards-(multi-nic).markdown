---
layout: post
title:  How to Configure an Environment With Multiple Network-Cards (Multi-NIC)
categories: XAP97
parent: networking-how-tos.html
weight: 500
---

{% summary %}Configuring GigaSpaces for a machine with multiple network cards. By default all network cards are used; you can limit GigaSpaces to specific ones.{% endsummary %}

# Overview

GigaSpaces can be configured for a multiple network-card environment. For security reasons, network administrators may choose to configure their network with limited access of one card open to outside connections, and another card for internal connections. The default network card configuration is not always set to the network card used for internal connection, and thus needs to be configured.

The `java.rmi.server.hostname` system property is used to resolve the NIC address for all services, which bind to a specific network interface, e.g. Jini unicast discovery lookup host, Webster, etc. More specifically, multicast and unicast discovery both use this property to limit and set the desired network interface card.

The **`NIC_ADDR`** environment variable is exposed as part of the `<GigaSpaces Root>\bin\setenv` script. By default, this value is configured to use the hostname of the machine.

Since the `java.rmi.server.hostname` system property is set by default to the `NIC_ADDR` environment variable, and propagated across all product components/layers; in most cases, you don't need to edit the `setenv` file or any other configuration file.

To apply this configuration easily, the `NIC_ADDR` variable can be passed at the **script level** of each node startup, before the call to `setenv`, thus overriding the default value set for this property in the `setenv` script.

{% note icon=false %}

{% indent %}
The following procedure explains the general configuration process required to test and configure the Multi-NIC settings in GigaSpaces.
**Please refer to these sections only if the out-of-the-box settings fail to work**.
{% endindent %}

{% endnote %}

{% exclamation %} Make sure your network and machines running GigaSpaces are configured to have multicast enabled. See the [Multicast Configuration](./how-to-configure-multicast.html) section for details on how to enable multicast.

# Configuring GigaSpaces for Multiple NICs

1. [Viewing the network interface information](./advanced-multi-nic-configuration.html#1) (optional)
1. [Specifying a network card to bind the lookup service](./advanced-multi-nic-configuration.html#2)
1. [Limiting use to a specific network interface (multicast only)](./advanced-multi-nic-configuration.html#3) (optional)
1. [Using unicast to register with a lookup service](./advanced-multi-nic-configuration.html#4) (optional)
1. [Testing your configuration](./advanced-multi-nic-configuration.html#5)
1. [Troubleshooting your configuration](./advanced-multi-nic-configuration.html#6), if you experience problems

{% refer %}For more details, refer to the **[Advanced Multi-NIC Configuration](./advanced-multi-nic-configuration.html)** section.{% endrefer %}
