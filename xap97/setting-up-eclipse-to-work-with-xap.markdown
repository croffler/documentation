---
layout: post
title:  Eclipse setup
categories: XAP97
parent: installation.html
weight: 600
---

{% compositionsetup %}
{% summary page|70 %}Setting up your IDE to Work With GigaSpaces{% endsummary %}

# Preparing your Development Environment

{% anchor 0 %}
Follow these steps to prepare your development environment:

{% comment %}
------------------------------------------------
Ensure you have JDK installed
------------------------------------------------
{% endcomment %}

- **Ensure you have a JDK installed** - you will need version 1.6 or higher, latest Java 1.6 is recommended.

#### Checking your JDK version

To check your installed Java version:

1. Open a command line window.
1. Run **`set JAVA_HOME`**
1. A response similar to this suggests you have a JDK installed:

{% highlight java %}
JAVA_HOME=C:\jdk1.6
{% endhighlight %}

# To check the JDK version, run **`%JAVA_HOME%\bin\java \-version`**

A response like this from Java indicates you have a good JDK installed:

{% highlight java %}
java version "1.6.0_23"
Java(TM) SE Runtime Environment (build 1.6.0_23-b05)
Java HotSpot(TM) Client VM (build 11.0-b16, mixed mode, sharing)
{% endhighlight %}

If your installed JDK version is lower then 1.5 or none is installed, see below on how to install one.

#### Installing a proper JDK (Java Development Kit)

- To install JDK 1.6, download and install [**JDK 6 Update X**](http://java.sun.com/javase/downloads/index.jsp)

{% comment %}
- The `JAVA_HOME` environment variable points to the correct JDK (not JRE) directory before running GigaSpaces. For example, `D:\Java\jdk1.6`.
- The `JAVA_HOME` environment variable should be added to the beginning of the `Path` environment variable. For example, `%JAVA_HOME%;SystemRoot%\system32;%SystemRoot%;%SystemRoot%`
- Your network and machines running GigaSpaces are configured to have multicast enabled. See the [Multicast Configuration](Multicast Configuration) section for details on how to enable multicast.
{% endcomment %}

{% anchor 1 %}

{% comment %}
------------------------------------------------
Download and install GigaSpaces zip
------------------------------------------------
{% endcomment %}

- **Download and unzip the latest XAP release** from the [downloads page](http://www.gigaspaces.com/LatestProductVersion).
{% anchor 2 %}

{% comment %}
------------------------------------------------
Download and install Eclipse zip
------------------------------------------------
{% endcomment %}

- **Install a Java IDE**: If you don't have an IDE installed, you can [download and unzip the Eclipse IDE for Java Developers](http://www.eclipse.org/downloads), or the [IntelliJ IDEA](http://www.jetbrains.com/idea/download/index.html) IDE (we recommend the Ultimate Edition because of its excellent Spring framework support).
If you're using Eclipse, it is also recommended to install the [Spring Tool Suite plugin for Eclipse](http://www.springsource.com/developer/sts).

# Steps to run the application inside Eclipse IDE

1. Start Eclipse. A **Workspace Launcher Dialog** appears.
1. Write a new workspace name or select one of your existing workspaces, and click the **OK** button.
1. To import the project, select **File > Import ...** to open the import dialog
1. Select **Existing projects into workspace* and click *Next** to open the import project dialog
1. In the **Select root directory* field click the *Browse** button to open the browse dialog
1. Select the folder `/examples/helloworld` and click **OK**
1. Make sure all 3 projects are selected: **hello-common**, **hello-processor** and **hello-feeder**
1. Click **Finish**
1. Create a new Eclipse environment variable called **GS_HOME**, and point it to your GigaSpaces installation Root folder

1. Right Click on the **hello-common** project in the **Package Explorer tab** to open the _context menu_
1. Select **Build Path > Configure Build Path...** to open the _Java Build Path dialog_
1. Select the **Libraries tab* and click the *Add Variable...** button to open the _New Variable Classpath Entry dialog_
1. Click the **Configure Variables...** button to open the _Classpath Variables dialog_
1. Click the **New...** button to open the _New Variable Entry_ dialog
1. In the **Name** field write `GS_HOME` to name the variable
1. Click the **Folder...** button and browse to **your GigaSpaces installation root folder**
1. Select your **GigaSpaces installation root folder** and click **OK**
1. Click **OK** and **OK** again
1. Click **Yes** to do full rebuild
1. Close remaining dialogs
