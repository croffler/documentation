---
layout: post
title:  Configuration File
categories: XAP97
parent: cpp-api-basics.html
weight: 300
---

{% summary page|65 %}C++ configuration file and setting the JVM options.{% endsummary %}

# Overview

Configuring c++ client settings is done using the `config.xml` file located under `cpp\config`.
The user can change the name and location of the configuration file by defining the Environment variable JVMCONFIG.

# c++ Configuration File Example

{% highlight java %}
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <GigaSpacesCpp>
    <Runtime>
      <JvmSettings>
        <!--add key="JVMPath" value="C:\Program Files\Java\jdk1.6.0_01\jre\bin\client" /-->
        <add key="ClassPath" value="$JSHOMEDIR/lib/ext/TestClasses.jar" />
        <add key="TraceLevel" value="STDERR ERROR DEBUG INFO TOFILE=logfile.txt " />
        <add key="InitialHeapSize" value="64m" />
        <add key="MaximumHeapSize" value="512m" />
        <add key="CheckJNI" value="true" />
        <add key="Loader" value="com/gigaspaces/javacpp/CXXProcessingUnit" />
        <!--<add key="SourceClassPath" value="$JSHOMEDIR/classes;$JSHOMEDIR;$JSHOMEDIR/src/java/resources;
         $JSHOMEDIR/cpp/java/src/bin;$JSHOMEDIR/lib/jini/jsk-lib.jar;
         $JSHOMEDIR/lib/jini/jsk-platform.jar;$JSHOMEDIR/lib/jini/reggie.jar;$JSHOMEDIR/lib/ServiceGrid/gs-service.jar;
         $JSHOMEDIR/tools/lib/jms.jar;$JSHOMEDIR/tools/lib/backport-util.jar" />-->
      </JvmSettings>
      <Options>
        <!--<add value="-Djava.util.logging.config.file=$JSHOMEDIR\config\gs_logging.properties"/>
        <add value="-agentlib:jprofilerti=port=8849"/>
        <add value="-Xbootclasspath/a:d:\Program Files\jprofiler5\bin\agent.jar"/>-->

        <!--<add value="-Dcom.sun.management.jmxremote.port=5003" />
        <add value="-Dcom.sun.management.jmxremote.ssl=false" />
        <add value="-Dcom.sun.management.jmxremote.authenticate=false" />-->
        <!--<add value="-Dcom.gs.onewaywrite=true" />-->
        <!--<add value="-Xdebug" />
        <add value="-Xnoagent" />
        <add value="-Djava.compiler=NONE" />
        <add value="-Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8001" />-->
        <!--<add value="-verbose:class" />-->
      </Options>
    </Runtime>
  </GigaSpacesCpp>
</configuration>
{% endhighlight %}

# JVM Settings

Some options should be predefined in the `JvmSettings` section:

{: .table .table-bordered}
| Name | Description |
|:-----|:------------|
| `ClassPath` | Adds Java classes to the JVM classpath |
| `TraceLevel` | Sets the c++ trace levels and output file |
| `InitialHeapSize` | Intial JVM heap size |
| `MaximumHeapSize` | Maximum heap size |
| `SourceClassPath` | Adds Java classes, used for debugging |

# Options

Any value that is added here is added to the command that creates the JVM.

Any key can be added.

## Debugging

To debug from Eclipse, remove the remark from the following lines:

{% highlight xml %}
<\!--<add value="-Xdebug" />
<add value="-Xnoagent" />
<add value="-Djava.compiler=NONE" />
<add value="-Xrunjdwp:transport=dt_socket,server=y,suspend=y,address=8001" />-\->
{% endhighlight %}

This allows the client to connect from its Java debugger.

## Connecting to JMX

Remove the remark from the following lines for connecting a JMX client:

{% highlight xml %}
<\!--<add value="-Dcom.sun.management.jmxremote.port=5003" />
<add value="-Dcom.sun.management.jmxremote.ssl=false" />
<add value="-Dcom.sun.management.jmxremote.authenticate=false" />-\->
{% endhighlight %}
