---
layout: post
title:  Administration and Monitoring API Security
categories: XAP97
parent: security-administration.html
weight: 300
---

{% summary %}Applying security to Admin API operations{% endsummary %}

# Overview

{% refer %}[Administration and Monitoring API](./administration-and-monitoring-api.html){% endrefer %}
The Admin API provides a way to administer and monitor all on GigaSpaces services and components using a simple API. The API, amongst others, provides the ability to operate on the currently running GigaSpaces Agents, GigaSpaces Managers, GigaSpaces Containers, Lookup Services, Processing Units and Spaces.

# Constructing the Admin instance

When using a secured Service Grid, the `Admin` instance needs to be constructed with a _principal_ which is granted sufficient privileges based on the operations being performed using the administration API. For example, grant **`Manage Grid`** to start a Grid Service Manager (GSM) and grant ***`Provision PU`** to deploy a processing unit.

The following creates an `Admin` instance with the user "user/password".

{% highlight java %}
Admin admin = new AdminFactory().addGroup("gigaspaces").credentials("user", "password").createAdmin();
{% endhighlight %}

For security other than username/password see [Custom Authentication]

# Space Deployment

Deploying a secured Space:

{% highlight java %}
...
admin.getGridServiceManagers().deploy(new SpaceDeployment("mySpace").secured(true));
{% endhighlight %}

Deploying a secured Space with credentials supplied. These credentials propagate to internal services, such as Space Filters.

{% highlight java %}
...
admin.getGridServiceManagers().deploy(new SpaceDeployment("mySpace").userDetails("myUser", "myPassword"));
{% endhighlight %}

# Processing Unit Deployment

Deploying a secured Processing Unit. This will deploy a Processing Unit with a secured embedded Space.

{% highlight java %}
...
admin.getGridServiceManagers().deploy(new ProcessingUnitDeployment("myPu").secured(true));
{% endhighlight %}

Deploying a secured Processing Unit with credentials supplied. With this approach, credentials do not need to be hardcoded in the `pu.xml` declaration. These credential propagate to all the beans which require a proxy to the space.

{% highlight java %}
...
admin.getGridServiceManagers().deploy(new ProcessingUnitDeployment("myPu").userDetails("myUser", "myPassword"));
{% endhighlight %}
