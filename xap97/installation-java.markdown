---
layout: post
title:  Java
categories: XAP97
parent: installation.html
weight: 200
---


{% summary %}Requirements and how to install GigaSpaces with Windows, Linux or Unix.{% endsummary %}

# Overview

GigaSpaces XAP is 100% pure Java, and therefore can run on any UNIX or Windows machine that supports Java.



{%anchor Prior-to-Installation%}

# Prior to Installation

**Prior to the GigaSpaces installation, make sure**:

- Review the release notes for the (supported platforms](/release_notes).
- [JDK](http://java.sun.com/javase/downloads/index.jsp) (6 or later) is installed (for example, **JDK 6 Update 39**) 
- Set the `JAVA_HOME` environment variable to the JDK (not JRE) directory (for example, `D:\java\jdk1.6.0_39`).
- Set the `PATH` environment variable to include `JAVA_HOME\bin` (for example, `%JAVA_HOME%\bin;%SystemRoot%\system32;%SystemRoot%`
- Optional: The network and machines running GigaSpaces are configured to enable multicast (see the [Multicast Configuration](./how-to-configure-multicast.html) for more information).
- Set the `NIC_ADDR` environment variable to the machine's IP address.

{%note title=Using JRE instead of JDK%}It is recommended to use a JDK (Java Development Kit), and not a JRE (Java Runtime Environment). If you do decide to use a JRE, make sure the `JAVA_HOME` environment variable points to the correct JRE directory, and remove JDK-specific command-line arguments, like `-server`, which do not exist in JRE.{%endnote%}

# Installing on Windows

Unzip the ZIP file using your favorite unzip tool (e.g., WinZip) to the location of your choice. Unzipping the file creates a `<GigaSpaces Root>` directory (e.g. `{{ site.latest_gshome_dirname }}`) with the following files and folders:

![win_dirtree_XAP95.jpg](/attachment_files/win_dirtree_XAP95.jpg)

**What's Next?**

- To verify a local installation, a remote installation, and the cluster configuration, refer to the [Testing System Environment](./testing-system-environment.html) section.
- See the [Quick Start Guide](/tutorials/index.html) for your first steps with GigaSpaces.


# Installing on Linux

Step 1. Navigate into the directory where you want to install GigaSpaces XAP, e.g. `opt`, and execute an `unzip` command using the path to the GigaSpaces zip file. For example:

{% highlight java %}
unzip {{ site.latest_build_filename }}
{% endhighlight %}

Step 2. Make sure all `sh` file(s) in the `/bin` and the `/examples` directory are in executable mode, meaning you can run them from your machine. To check this, use the `ls \-all` command for the relevant directory, and make sure that `x` is included in the file permissions.

Step 3. Make sure all the machines running GigaSpaces can ping each other and their hosts file include the machine IP.

**What's Next?**

- To verify a local installation, a remote installation, and the cluster configuration, refer to the [Testing System Environment](./testing-system-environment.html) section.
- See the [Quick Start Guide](/tutorials/index.html) for your first steps with GigaSpaces.

{% anchor 2 %}

# Important Tips

Before you begin working with GigaSpaces, it is recommended to review the [Performance Tuning and Considerations](./performance-tuning-and-considerations.html) sections and apply the required changes. For example, you may need to update the [**max file descriptors limit**](./tuning-infrastructure.html#Max Processes and File Descriptors Limit) before you begin.

{% info %}
 The recommendation is to review at least the following sections:

- [Tuning Infrastructure](./tuning-infrastructure.html)
- [Tuning GigaSpaces Performance - Basics](./tuning-gigaspaces-performance---basics.html)
- [Tuning Java Virtual Machines](./tuning-java-virtual-machines.html)
- [Benchmarking the platform](./moving-into-production-checklist.html)
{% endinfo %}


{%children%}