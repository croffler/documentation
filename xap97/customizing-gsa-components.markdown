---
layout: post
title:  Customizing GSA Components
categories: XAP97
parent: the-runtime-environment.html
weight: 200
---


{% summary %}Creating custom components for GSA{% endsummary %}

# Overview

GSA manages different process types. Each process type is defined within the `<GSHOME>\config\gsa` directory in an xml file that identifies the process type by its name.

{% tip %}You can change the default location of the GSA configuration files using the `com.gigaspaces.grid.gsa.config-directory` system property.{% endtip %}

The following are the process types that come out of the box:

{: .table .table-bordered}
|Processes Type|Description|XML config file name|Properties file name|
|:-------------|:----------|:-------------------|:-------------------|
|gsc|Defines a [Grid Service Container}(./service-grid.html#gsc)|gsc.xml|gsc.properties|
|gsm|Defines a [Grid Service Manager](./service-grid.html#gsm)|gsm.xml|gsm.properties|
|lus|Defines a [Lookup Service](./service-grid.html#lus)| lus.xml|lus.properties|
|gsm_lus|Defines a [Grid Service Manager](./service-grid.html#gs) and [Lookup Service|Service Grid#lus] within the same JVM|gsm_lus.xml|gsm_lus.properties|
|esm|Defines an Elastic Service Manager which is required for deploying [Elastic Processing Unit](./elastic-processing-unit.html)|esm.xml|esm.properties |

Here is an example of the gsc xml configuration file:

{% highlight xml %}
<process initial-instances="script" shutdown-class="com.gigaspaces.grid.gsa.GigaSpacesShutdownProcessHandler" restart-on-exit="always">
 <script enable="true" work-dir="${com.gs.home}/bin"
  windows="${com.gs.home}/bin/gsc.bat"
  unix="${com.gs.home}/bin/gsc.sh">
  <argument></argument>
 </script>
 <vm enable="true" work-dir="${com.gs.home}/bin"
   main-class="com.gigaspaces.start.SystemBoot">
   <input-argument></input-argument>
   <argument>com.gigaspaces.start.services="GSC"</argument>
 </vm>
 <restart-regex>.*OutOfMemoryError.*</restart-regex>
</process>
{% endhighlight %}

The GSA can either spawn a script based process, or a pure JVM (with its arguments) process. The GSC for example, allows for both types of process spawning.

- The `initial-instances` parameter controls what type of spawning will be performed when the GSA spawns processes by itself (and not on demand by the Admin API).
- The `shutdown-class` followed by the `restart-on-exit` flag, controls if the process will be restarted upon termination.
-- There are three types of values:
--- restart-on-exit="always": Always restarts the process if it exits
--- restart-on-exit="never": Never restarts the process if it exists
--- restart-on-exit="!0": Restarts the process only if the exit code is different than 0
-- The `shutdown-class` is an implementation of `com.gigaspaces.grid.gsa.ShutdownProcessHandler` interface and provides the default shutdown hooks before and after shutdown of a process, to make sure it is shutdown properly. The `shutdown-class` can be omitted.
- The `restart-regex` (there can be more than one element) is applied to each console output line of the managed process, and if there is a match, the GSA will automatically restart the process. By default, the GSC will be restarted if there is an `OutOfMemoryError`.
