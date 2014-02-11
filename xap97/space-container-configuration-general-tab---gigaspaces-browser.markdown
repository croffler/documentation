---
layout: post
title:  Space Container Configuration General Tab - GigaSpaces Browser
categories: XAP97
parent: managing-space-containers---gigaspaces-browser.html
weight: 200
---

{% summary %}Home directory, license, container socket port, security mode.{% endsummary %}

# Overview

**You may view the following container attributes in the General tab:**

- **Home Directory** -- Read only field. Displays the installation directory of the GigaSpaces Server.
- **License** -- Use this field to change the GigaSpaces Server license key.
- **Container Socket Port** -This is the port used by the container to export its stub. The default value is `0`.
- **Security Mode** -- The space container provides basic security capabilities that control whether users have full control or read-only access. **Read Only** specifies that all users should be blocked from creating and destroying spaces, shutting down containers, setting container configuration and restarting a container. **Full Control** specifies that all users are allowed to perform all operations on the container. If the configuration is set to **Read Only**, the only way to change it to **Full Control** is through the configuration file. This prevents users from changing the restrictions on a space browser.

![Container Configuration General Tab - GigaSpaces Browse.jpg](/attachment_files/Container Configuration General Tab - GigaSpaces Browse.jpg)
