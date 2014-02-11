---
layout: post
title:  gsInstance
categories: XAP97
parent: advanced-scripts.html
weight: 100
---

{% summary %}Loads a space container, one space, an embedded Reggie, and an embedded Webster, using the `gsInstance` script. {% endsummary %}

# Overview

This section explains how to start a light version of the GigaSpaces server, which loads a container and one space, using the `gsInstance` script. The `gsInstance` (which calls [SpaceFinder](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/j_spaces/core/client/SpaceFinder.html)) starts by default embedded Reggie and Webster services.

## Starting Embedded Mahalo

By default, `gsInstance` does not start an embedded Mahalo (Jini Transaction Manager).

You can enable this option in one of the following ways:

- Setting the following option to `true` in your container schema:

{% highlight xml %}
<embedded-services>
...
<mahalo>
	<!-- If true, will start an embedded Mahalo Jini Transaction Manager. Default value: false -->
    <start-embedded-mahalo>${com.gs.start-embedded-mahalo}</start-embedded-mahalo>
</mahalo>
{% endhighlight %}

- Setting the following option in the `gsInstance` command line:

    -Dcom.gs.start-embedded-mahalo=true

- Setting XPath in the `<GigaSpaces Root>\config\gs.properties` file:

    com.j_spaces.core.container.embedded-services.mahalo.start-embedded-mahalo=true

{% tip %}
GigaSpaces supports space monitoring and management using JMX - The Java Management Extensions. For more details, refer to the [JMX Management](./space-jmx-management.html) section.
{% endtip %}

{% note %}
When running `gsIntance`, the Jini Lookup Service runs implicitly. When having many Jini Lookup Services running across the network, the spaces and clients might be overloaded since they publish themselves into the Lookup Service, or are trying to get updates about newly registered services.
A good practice is to have two Lookup Services running using the `startJiniLUS` command located in the `<GigaSpaces Root>\bin` directory, or the GSM command located in the `<GigaSpaces Root>\bin` folder. This ensures no single point of failure for the Lookup Service.
{% endnote %}

# Syntax & Arguments

The full `gsInstance` syntax (the arguments passed below are optional):

{% highlight java %}
gsInstance "/./newSpace?schema=persistent" "../../classes" "-DmyOwnSysProp=value -DmyOwnSysProp2=value"
{% endhighlight %}

The `gsInstance` arguments are passed through the command line. These arguments are optional - if you do not want to pass any arguments, you don't have to specify anything in the command line, as seen below:

{% highlight java %}
gsInstance
{% endhighlight %}

You can use three arguments. All arguments must be enclosed by quotes (`" "`). If used, the arguments must be entered in the following order (descending):

{: .table .table-bordered}
| Argument | Description |
|:---------|:------------|
| Argument 1 | Defines a space URL. The value is set into the `SPACE_URL` variable. If no value is passed for this argument, the space URL defined in the `gsInstance` script is used. |
| Argument 2 | Defines a path which will be appended to the beginning of the used classpath. The value you define is set into the `APPEND_TO_CLASSPATH_ARG` variable. If no value is passed, the classpath defined in the `gsInstance` script is used. |
| Argument 3 | Defines additional command line arguments such as system properties. The value is set into the `APPEND_ADDITIONAL_ARG` variable. |

If you are using the third and/or second argument only, **you must use empty quote signs for the argument or arguments that come before the one you are using**. For example:

    gsInstance "" "" "-DmyOwnSysProp=value -DmyOwnSysProp2=value"

In the example above, only the third argument is used, so two pairs of empty quote signs are written before it. In this case, the default URL and classpath (defined in the `gsInstance` script) are used, and only the system properties are appended.



