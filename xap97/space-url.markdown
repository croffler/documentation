---
layout: post
title:  Space URL
categories: XAP97
parent: the-space-component.html
weight: 400
---

{% summary %}An address, passed to `GigaSpace`, used to connect to a space and remotely create new spaces as well as enable various characteristics.{% endsummary %}

# Overview

## What is SpaceURL?

The **[SpaceURL](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/j_spaces/core/client/SpaceURL.html)** object is an address, passed to the `GigaSpace` API, used to connect to a space and remotely create new spaces, as well as to enable various characteristics.

# Usage

In order to locate a space you should specify its URL. The SpaceURL is used as part of the **[Space Component](./the-space-component.html#SpaceComponent-URLProperties)* and in set using the OpenSpaces *`UrlSpaceFactoryBean`** (and the deprecated `SpaceFinder.find`) API, cluster configuration, management tools as well as by GigaSpaces C++,.Net.

The general format of the space URL is:

{% highlight xml %}
<protocol>://<host name>:<port>/<container name>/<space name>?<properties>
{% endhighlight %}

{% infosign %} A more commonly used format is using the **[OpenSpaces Configurer API](./programmatic-api-(configurers).html)** e.g:

{% highlight java %}
UrlSpaceConfigurer spaceConfigurer = new UrlSpaceConfigurer("/./space").fifo(true)
                                                                       .lookupGroups("test");
IJSpace space = spaceConfigurer.space();

// ...

// shutting down / closing the Space
spaceConfigurer.destroy();
{% endhighlight %}

{: .table .table-bordered}
| Name | Description |
|:-----|:------------|
| Protocol | `[jini](java)`{% wbr %}- Jini -- Remote access using Jini for lookup{% wbr %}- Java -- Local (embedded) access |
| Host name/IP | The machine host name/IP running the space container. May be \* when Jini is used as a protocol. In this case the space is located using multicast or unicast with search path. |
| Port | The Jini lookup port. If no port is specified the default port will be used |
| Container Name | The name of the container that holds the space. May be \* when Jini is used as a protocol. In this case the container will be ignored when performing lookup and the space will be searched regardless of the container that holds it. |
| Space Name | The space name to search. The same name defined when space has been created via the Space browser or the `createSpace` utility. |
| Properties String | (Optional) named value list of special properties. |

{% exclamation %} Make sure your network and machines running GigaSpaces are configured to have multicast enabled. See the [How to Configure Multicast](./how-to-configure-multicast.html) section for details on how to enable multicast.

# URL Properties

The following are optional property string values.

These strings are defined as part of the `SpaceURL` class (`com.j_spaces.core.client.SpaceURL`; see [Javadoc](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/j_spaces/core/client/SpaceURL.html)) as static attributes.

{: .table .table-bordered}
| Property name | Property String | Description | Optional values |
|:--------------|:----------------|:------------|:----------------|
| `ANY` | * | Used with Jini protocol to indicate any host or container name | |
| `CREATE` | `create` | Creates a new space using the container's default parameters. New spaces use the default space configuration file. Example: `java://localhost:10098/containerName`{% wbr %}`/JavaSpaces?create=true` | |
| `EMBEDDED_SPACE`{% wbr %}`_PROTOCOL` | java: | Start the space in local embedded mode. Make sure you have the `com.gs.home` JVM property defined to specify the space configuration file directory | |
| `FIFO_MODE` | fifo | Indicates that all take/write operations be conducted in FIFO mode. Default is false. Example: `jini://localhost:10098/containerName`{% wbr %}`/JavaSpaces?fifo=true` | `false` |
| `GROUPS` | `groups` | The Jini Lookup Service group to find container or space using multicast. Example: `jini://*/containerName/spaceName?groups=grid`{% wbr %}{% infosign %} The default value of the `LOOKUPGROUPS` variable is the GigaSpaces version number, preceded by `XAP`. For example, in GigaSpaces XAP 6.0 the default lookup group is `XAP6.0`. This is the lookup group which the space and Jini Transaction Manager register with, and which clients use by default to connect to the space.{% wbr %}{% exclamation %} Jini groups are irrelevant when using unicast lookup discovery -- they are relevant only when using multicast lookup discovery. If you have multiple spaces with the same name and you are using unicast lookup discovery, you might end up getting the wrong proxy. In such a case, make sure you have a different lookup for each space, where each space is configured to use a specific lookup. A good practice is to have different space names. | `Group name` |
| `LOCATORS` | `locators` | Instructs the started space or a client to locate the Jini Lookup Service on specific host name and port. For more details please refer to [How to Configure Unicast Discovery](./how-to-configure-unicast-discovery.html#HowtoConfigureUnicastDiscovery-Configuringthelookuplocatorsproperty) page. | |
| `JINI_PROTOCOL` | `jini:` | Using JINI Lookup service to search for the space | |
| `LOCAL_CACHE`{% wbr %} `_UPDATE_MODE` | `updateMode` | Push or pull update mode. Example: {%wbr%}`jini://localhost:10098/containerName /JavaSpaces?useLocalCache&updateMode=1` | `UPDATE_`{% wbr %} `MODE`{% wbr %} `_PULL`{% wbr %} `= 1` {% wbr %} `UPDATE_`{% wbr %} `MODE`{% wbr %} `_PUSH`{% wbr %} `= 2` |
| `SECURITY_MANAGER` | `security`{% wbr %} `Manager` | When false, `SpaceFinder` will not initialize RMISecurityManager. Default is `true`. Example: `jini://localhost:10098/containerName`{% wbr %} `/JavaSpaces?securityManager=false` | |
| `TIMEOUT` | `timeout` | The max timeout in \[ms\] to find a Container or Space using multicast {% wbr %} `jini://` protocol. Default: 5000\[ms\] Example: `jini://<code>*</code>/containerName`{% wbr %} `/JavaSpaces?timeout=10000` | |
| `USE_LOCAL`{% wbr %} `_CACHE` | `useLocalCache` | Turn Master-Local Space mode.By default Master-Local mode is turned off. To enable master local have the `useLocalCache` as part of the URL |  |
| `VERSIONED` | versioned | When false, optimistic lock is disabled. In a local cache and views the default is `true`, otherwise the default value is `false`. Example: `jini://localhost:10098/containerName/JavaSpaces?versioned=false` | |
| `CLUSTER_NAME` | `clustername` | The cluster name to lookup using multicast. The returned object is a clustered proxy. | |
| `CLUSTER_GROUP` | `clustergroup` | The cluster group to lookup using multicast. The returned object is a clustered proxy. | |
| `CLUSTER_SCHEMA` | `cluster_schema` | The cluster schema XSL file name to be used to setup a cluster config on the fly in memory. If the `?cluster_schema option` is passed e.g. `?cluster_schema=sync_replication`, the system will use the `sync_replication-cluster-schema.xsl` together with a cluster Dom which will be built using user's inputs on regards # of members, # of backup members etc. | |
| `SCHEMA_NAME` | `schema` | Using the schema flag, the requested space schema name will be loaded/parsed while creating an embedded space. If the space already has configuration file then the requested schema will not be applied and the that file exist, it will overwrite the default configuration defined by the schema. Note that when using the option ?create with java:// protocol, the system will create a container, space and use the default space configuration schema file (default-space-schema.xml) | |
| `CLUSTER_TOTAL`{% wbr %} `_MEMBERS` | `total_members` | The `total_members` attribute in the space URL stands for the total number of cache members within the cache cluster.{% wbr %}The number is used to create the list of members participating in the cluster on the fly based on the cache name convention. This pattern is used to avoid the need for creating a cluster topology file. {% wbr %}The number of actual running cache instances can vary dynamically between `1<=total_members`.{% wbr %}The format of the `total_members` = number of primary instances, number of backup instances per primary. In this example the value is 4,2 which means that this cluster contains up to 4 primary instances each containing 2 backup instances. The backup\_id is used to define whether the instance is a backup instance or not.{% wbr %}If this attribute is not defined the instance will be considered a primary instance. The container name will be translated in this case to \[cache name\]\_container\[id\]\[backup_id\].{% wbr %}In this case it will be expanded to mySpace_container1\_1 | |
| `CLUSTER_BACKUP_ID` | `backup_id` | Used in case of Partitioned Cache (when adding backup to each partition). The backup_id is used to define whether the instance is a backup instance or not. If this attribute is not defined the instance will be considered a primary cache instance.{% wbr %}The container name will be translated in this case to \[cache name\]_container\[id\]_\[backup_id\].{% wbr %} In this case it will be expanded to mySpace_container1_1. | |
| `NO_WRITE_LEASE` | `NOWriteLease` | If true - Lease object would not return from the write/writeMultiple operations. Default: false | |
| `CLUSTER_MEMBER_ID` | `id` | The id attribute is used to distinguish between cache instances in this cluster. | |
| `PROPERTIES_FILE`{%wbr%}`_NAME` | `properties` | if properties property is used as part of the URL space, space and container schema will be loaded and the properties listed as part of the properties file (`[prop-file-name].properties`) which contains the values to override the schema space/container/cluster configuration values that are defined in the schema files.{% wbr %}Another benefit of using the ?properties option is when we want to load system properties while VM starts or set SpaceURL attributes. See /config/gs.properties file as a reference. | |
| `MIRROR` | `mirror` | When setting this URL property it will allow the space to connect to the Mirror service to push its data and operations for asynchronous persistency.{% wbr %}Example:{% wbr %}`/./JavaSpace?cluster_schema=sync_replicated&mirror`{% wbr %} Default: no mirror connection | |

Example for space URL using Space URL options:

{% highlight java %}
jini://*/*/mySpace?useLocalCache&versioned=false
/./mySpace?cluster_schema=partitioned&total_members=4&id=1
{% endhighlight %}

## "." Space Container Notation

The Space URL uses the following notation to start a space: `/./<Space Name>`
For example: `/./mySpace`

When using that space URL the system will instantiate (create) a space instance named `mySpace` using the default schema configuration. The default schema is set to transient space configuration and it is equivalent to using the following URL:
    java://localhost:10098/mySpace_container/mySpace?schema=default

{% tip %}
You can use "." as the container name in the space URL. A value of "." as the container name will be translated to `<space name>_container` name. In the above example the container name is explicitly defined as `mySpace_container`.
{% endtip %}

When a URL is provided without the protocol (java) and host name (localhost), the `SpaceFinder/CacheFinder` treats /./mySpace as
    java://localhost:10098/mySpace_container/mySpace?schema=default

# Examples

## Accessing Remote Space Using Jini Lookup Service - Unicast Discovery

- `JINI://hostname/*/myspace`
- `JINI://mylookuphost/mycontainername/myspace`

## Accessing Remote Space Using the Jini Lookup Service - Multicast Discovery

- `JINI://*/mycontainername/myspace`
- `JINI://*/*/myspace`

## Starting Embedded Space Using the Java Protocol

- `JAVA://containerHostName:port/myContainerName/spaceName`
- `/./mySpace (which translates to java://localhost:10098/containerName/mySpace?schema=default)`
- `/./mySpace?schema=cache (which translates to java://localhost:10098/containerName/mySpace?schema=cache)`

{% anchor 1 %}

## Distributed Unicast-Based Lookup Service Support

In environments that do not support multicast, you can use the new `locators` space URL property to instruct the started space or a client to locate the Jini Lookup Service on specific host name and port.

The locators are used in a similar way to the `groups` URL property.

The locators can have a comma-delimited lookup hosts list:

{% highlight java %}
SpaceFinder.find("/./Space?groups=g1,g2,g3&locators=h1:port,h2:port,h3:port)
{% endhighlight %}

The following URL formats are now supported:

{% highlight java %}
jini://*/*/space_name?locators=h1:port,h2:port,h3:port
jini://host1:port1,....host n:port n/container-name/space_name
jini://host1:port1,....host n:port n/container-name/space_name?locators=h1:port,h2:port,h3:port
jini://host1:port1/container-name/space name?locators=h1:port,h2:port,h3:port
{% endhighlight %}

## Running Replicated Space

To start three space instances using the [replicated cache topology](/product_overview/terminology---data-grid-topologies.html), which enables replicating their data and operations synchronously, you should have the following commands:

{% highlight java %}
gsInstance "/./mySpace?cluster_schema=sync_replicated&total_members=3&id=1"
gsInstance "/./mySpace?cluster_schema=sync_replicated&total_members=3&id=2"
gsInstance "/./mySpace?cluster_schema=sync_replicated&total_members=3&id=3"
{% endhighlight %}

To access the replicated space, the client application should use the following url:

{% highlight java %}
jini://*/*/mySpace
{% endhighlight %}

## Running Partitioned Space

To start three space instances using the [partitioned cache topology](/product_overview/terminology---data-grid-topologies.html) where each partition stores different portions of the data, you should have the following calls:

{% highlight java %}
gsInstance "/./mySpace?cluster_schema=partitioned&total_members=3&id=1"
gsInstance "/./mySpace?cluster_schema=partitioned&total_members=3&id=2"
gsInstance "/./mySpace?cluster_schema=partitioned&total_members=3&id=3"
{% endhighlight %}

To access the partitioned space, the client application should use the following url:

{% highlight java %}
jini://*/*/mySpace
{% endhighlight %}

## Running Embedded Space

You may run the replicated or partitioned space from within your application. In this case, the space instance will be running in the same memory address as the application - i.e. [embedded space](/product_overview/terminology---data-grid-topologies.html). See the following example for running three space instances in partitioned embedded mode.
Each `CacheFinder.find()` or `SpaceFinder.find()` call should be done from a different application process.

{% highlight java %}
IJSpace space = (IJSpace)SpaceFinder.find("/./mySpace?cluster_schema=partitioned&total_members=3&id=1");
IJSpace space = (IJSpace)SpaceFinder.find("/./mySpace?cluster_schema=partitioned&total_members=3&id=2");
IJSpace space = (IJSpace)SpaceFinder.find("/./mySpace?cluster_schema=partitioned&total_members=3&id=3");
{% endhighlight %}
