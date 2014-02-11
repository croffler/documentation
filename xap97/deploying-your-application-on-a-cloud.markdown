---
layout: post
title:  Deploying your Application on a Cloud
categories: XAP97
parent: packaging-and-deployment.html
weight: 300
---

{% summary %}How to Deploy an application with Data Grid and Processing Units on any Cloud using a recipe{% endsummary %}

# Overview

XAP 9 Comes with a built-in Cloudify recipe feature that allows the deployment and management of an entire application onto any cloud. For more information on supported Cloud and Cloud Drivers see the [Cloudify User Guide](http://www.cloudifysource.org/guide/). The following sections will demonstrate how to compose a recipe for deploying and managing your XAP application on the Cloud.

The following XAP types of services are supported:

- In memory data grid
- Stateful Procesing Units
- Stateless Processing Units
- Mirror Service

# Using a Stateless Processing Unit or a Web Processing Unit

{% highlight java %}
service {
  icon "icon.png"
  name "statelessPU"
  numInstances 3
  statelessProcessingUnit {
    binaries "servlet.war" //can be a folder, or a war file
    sla {
      memoryCapacity 128
      maxMemoryCapacity 128
      highlyAvailable false
      memoryCapacityPerContainer 128
    }
  }
}
{% endhighlight %}

# Using a Stateful Processing Unit

{% highlight java %}
service {
  icon "icon.png"
  name "stockAnalyticsFeeder"
  statefulProcessingUnit {
    binaries "stockAnalyticsFeeder.jar" //can be a folder, or a war file
    sla {
      memoryCapacity 128
      maxMemoryCapacity 128
      highlyAvailable false
      memoryCapacityPerContainer 128
    }
  }
}
{% endhighlight %}

# Adding a Mirror Service

{% highlight java %}
service {
  icon "icon.png"
  name "stockAnalyticsMirror"
  statelessProcessingUnit {
    binaries "stockAnalyticsMirror" //can be a folder, or a war file
    sla {
      memoryCapacity 256
      maxMemoryCapacity 256
      highlyAvailable false
      memoryCapacityPerContainer 256
    }
  }
}
{% endhighlight %}

# Packing Your Recipe

In order to have a mixture of services (XAP EPU and non XAP) you need to prepare the following structure:
![recipe_folder.png](/attachment_files/recipe_folder.png)
The application recipe should describe the different services and the dependencies between services:

{% highlight java %}
application {
	name="rt_app"

	service {
		name = "feeder"
		dependsOn = ["processor"]
	}
	service {
		name = "processor"
		dependsOn = ["rt_cassandra"]
	}
	service {
		name = "rt_cassandra"
	}
}
{% endhighlight %}

You can find a working example that includes a stateful and a stateless PU [here](https://github.com/Gigaspaces/rt-analytics/tree/master/rt_app).

# Deploying Your Recipe

{% info title=Useful Information %}
In order to use your license on the cloud environment you should perform the following:

- cd to `<XAP installation root>/tools/cli/plugins/ecs/<cloud name>/upload`
- create directory cloudify-overrides
- copy your license(<XAP installation root>/gslicense.xml) to the above directory.
{% endinfo %}

### Testing on a `localcloud`

XAP 9.0 comes with a cloud emulator called [`localcloud`](http://www.cloudifysource.org/guide/bootstrapping/bootstrapping_localcloud) that allows you to test the recipe execution

To start the localcloud environment:

- cd to `<XAP installation root>/bin/`
- Type `cloudify.sh/bat`
- In the Cloudify shell, type `bootstrap-localcloud` to start the localcloud services. This might take a minute or two to complete.
- Deploy the application using the `install-application` command:

{% highlight java %}
install-application c:/rt-app
{% endhighlight %}

You can track the progress in the shell and in the Web Management Console at localhost:8099.
For more information refer to [the cloudify application deployment guide](http://www.cloudifysource.org/guide/deploying/deploying_apps).

### Running on Any Cloud

To deploy your recipe to one a cloud environment, follow the below steps:

- Obtain your cloud's credentials and [configure the cloud driver](http://www.cloudifysource.org/guide/setup/post_installation_configuration.html))
- Bootstrap the cloud using [`bootstrap-cloud` command](http://www.cloudifysource.org/guide/bootstrapping/bootstrapping_process).
- [Install the application](http://www.cloudifysource.org/guide/deploying/deploying_apps) using the `install-application` command, as described in the previous section.
