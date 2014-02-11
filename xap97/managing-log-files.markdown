---
layout: post
title:  Managing Log Files
categories: XAP97
parent: gigaspaces-logging.html
weight: 200
---

{% summary %}Managing log file naming, and rolling over policies{% endsummary %}

# Overview

The log file names, location and format are all properties of the Java log `Handler`. GigaSpaces uses a rolling file handler implemented by the class `com.gigaspaces.logger.`**`RollingFileHandler`**`, which is based on Java's `java.util.logging.FileHandler`, but with extended functionality. It provides two policies that can trigger a "rollover" to a new file, and a customizable extension point for backing up files.

# Rolling Over to a New File

The rollover mechanism is based on two policies, whichever policy is triggered first:

- File size rolling policy (default 2MB)
- Time based rolling policy (default is daily)

# `formatter` property

The default log output formatting is determined by `GSSimpleFormatter` (see [Formatting Log Messages](./formatting-log-messages.html)).

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.formatter = com.gigaspaces.logger.GSSimpleFormatter
{% endhighlight %}

# `filename-pattern` Property

The file name pattern can be configured to include a placeholder for properties to resolve, such as homedir, host, pid and date. Each placeholder is identified by a set of curly brackets \{..\}. It may also be a placeholder for a custom defined property.

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.filename-pattern = {homedir}/logs/{date,yyyy-MM-dd~HH.mm}-gigaspaces-{service}-{host}-{pid}.log
{% endhighlight %}

To determine the place holder's value, we first look for an overriding system property. If no override was specified, and the property is one of the predefined properties (i.e. homedir, host, pid, date), its value is evaluated by the handler implementation. If the place holder is of a custom property, and no value is defined, the property is left as is. If any error occurs, it is reported and the property is replaced by an empty string. Example override by system property:

{% highlight java %}
-Dcom.gigaspaces.logger.RollingFileHandler.filename-pattern.date=yyyy-MM-dd
{% endhighlight %}

##### Customization Examples

**1.** One possible customization that might be of interest is to separate the log files into folders named after the host names.
To achieve this, the pattern would need to have the \{host\} placeholder as one of the directory paths - as follows:

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.filename-pattern = {homedir}/logs/{host}/{date,yyyy-MM-dd~HH.mm}-gigaspaces-{service}-{pid}.log

<GigaSpace>/logs/
  + host1
      - *.log
  + host2
      - *.log
{% endhighlight %}

**2.** We would like to be able to configure the path where GigaSpaces puts its logs.
Set the `\{homedir\`} property placeholder with the following system property:

{% highlight java %}
-Dcom.gigaspaces.logger.RollingFileHandler.filename-pattern.homedir = /dev/output/logs
{% endhighlight %}

And have the `filename-pattern` include the `homedir` key

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.filename-pattern = {homedir}/mylog.log
{% endhighlight %}

**3.** We would like to configure a custom filename-pattern property of our own.
Set a `\{mycustom\`} property placeholder with the following system property:

{% highlight java %}
-Dcom.gigaspaces.logger.RollingFileHandler.filename-pattern.mycustom = value
{% endhighlight %}

And have the `filename-pattern` include the `mycustom` property key

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.filename-pattern = ../{mycustom}/mylog.log
{% endhighlight %}

{% exclamation %} Note that the property value will have illegal path characters removed. (e.g. `/\:*?"<>|`)

# `append` Property

The append property specifies if output should be appended to an existing file. Default is set to false. Thus, if a file already exists by this name, a unique incrementing index to resolve the conflict will be concatenated. It will be added at the end of the filename replacing ".log" with "__\{unique\}.log" or at the end of the filename if the pattern doesn't end with ".log".

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.append = false
{% endhighlight %}

# `size-rolling-policy` Property

The file size rolling policy can be configured to roll the file when a size limit is reached. It specifies an approximate maximum amount to write (in bytes) to any one file. If this is zero, then there is no limit. If the property is omitted, then a default of 2MB is assumed.

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.size-rolling-policy = 2000000
{% endhighlight %}

# `time-rolling-policy` Property

The time based rolling policy can be configured to roll the file based on a certain recurring schedule. The time policy can be set to one of the following values: daily, weekly, monthly or yearly. If the property is omitted, then the default pattern of "daily" is assumed; meaning a daily rollover (at midnight). For example, if "monthly" is configured, the file will rollover at the beginning of each month.

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.time-rolling-policy = daily
{% endhighlight %}

# `backup-policy` Property

A backup-policy can be configured to backup files. By default a **NullBackupPolicy** is configured, which does nothing. It can be replaced by a **DeleteBackupPolicy** to keep a backup of files for a specified period. The **BackupPolicy** interface allows custom implementations to be plugged-in.

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.backup-policy = com.gigaspaces.logger.DeleteBackupPolicy
com.gigaspaces.logger.DeleteBackupPolicy.period = 30
com.gigaspaces.logger.DeleteBackupPolicy.backup = 10
{% endhighlight %}

For more information see [Backing-up Files With a Custom Policy](./backing-up-files-with-a-custom-policy.html)

# `debug-level` Property

The debug level (configured to one of logging Levels) is the level in which debug messages are displayed to the "standard" output stream. By default the level is configured to "CONFIG" which displays the log file name.

"_Log file: /export/users/gs/gigaspaces-xap/logs/2010-08-04~12.29-gigaspaces-cli-lab1-4422.log_"

{% highlight java %}
com.gigaspaces.logger.RollingFileHandler.debug-level = CONFIG
{% endhighlight %}

This can also be overridden by a system property.

# System property overrides

Any of the logger properties can be configured by a system property override, specified as follows:
`-Dcom.gigaspaces.logger.RollingFileHandler.\[property-name\]=\[property-value\]`

For example:

{% highlight java %}
-Dcom.gigaspaces.logger.RollingFileHandler.debug-level=OFF
{% endhighlight %}

