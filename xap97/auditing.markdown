---
layout: post
title:  Auditing
categories: XAP97
parent: security-administration.html
weight: 400
---

{% summary %}Auditing of authentication and operations{% endsummary %}

# Overview

GigaSpaces provides the ability to audit the authentication requests and operations performed on a secured service. It facilitates the logging mechanism to declare the audit log file, and the level of auditing. The level can be dynamically modified using the `java.util.logging JMX Extensions`. This allows an easy extension for custom auditing.

{% note %}
Currently auditing of operations is limited to Space operations.
{%endnote%}

# Configuration

The configurations should be placed in the logging configuration file `<GigaSpaces root>/config/gs_logging.properties`.

{% highlight java %}
# gs_logging.properties

com.gigaspaces.security.audit.enabled = true
com.gigaspaces.security.audit.level = SEVERE
com.gigaspaces.security.audit.handler = com.gigaspaces.security.audit.AuditHandler
{% endhighlight %}

This configuration can also be supplied using system properties.

{% highlight java %}
-Dcom.gigaspaces.security.audit.enabled=true -Dcom.gigaspaces.security.audit.level=SEVERE ...
{% endhighlight %}

The defaults of these configurations are:

{: .table .table-bordered}
| com.gigaspaces.security.audit.enabled | Enable/Disable security auditing; default is disabled (false) |
| com.gigaspaces.security.audit.level | Audit level of interest; default is OFF |
| com.gigaspaces.security.audit.handler | The Audit `java.util.logging.Handler` implementation accepting an `AuditLogRecord`; default is `AuditHandler` |

The `AuditHandler` is a declarable extension to the default GigaSpaces logging `Handler` (see [GigaSpaces Logging](./gigaspaces-logging.html)). As such, it accepts properties that configure the handler - amongst others are the logging message **formatter** and the **filename-pattern**.

{% highlight java %}
# gs_logging.properties

...
com.gigaspaces.security.audit.handler = com.gigaspaces.security.audit.AuditHandler

# Properties configuring the audit-handler:

com.gigaspaces.security.audit.AuditHandler.formatter = com.gigaspaces.logger.GSSimpleFormatter
com.gigaspaces.security.audit.AuditHandler.filename-pattern = {homedir}/logs/gigaspaces-security-audit-{service}-{host}-{pid}.log
{% endhighlight %}

# Audit Levels

{: .table .table-bordered}
| OFF     | Nothing is audited |
| SEVERE  | Authentication failure or invalid session |
| WARNING | Access denied due to insufficient privileges |
| INFO    | Authentication successful |
| FINE    | Access granted |

## Sample Output

A sample output snapshot with audit level set to `FINE`.

    2009-09-13 17:43:04,609  INFO  - Authentication successful; for user [gs] from host [lab/127.1.1.1]; session-id [-639278424]
    2009-09-13 17:43:09,453  FINE  - Access granted; user [gs] at host [lab/127.1.1.1] has [Write] privileges for class [com.eg.Pojo]; session-id [-639278424]
    2009-09-13 17:44:24,937  WARNING  - Access denied; user [gs] at host [lab/127.1.1.1] lacks [Take] privileges for class [com.eg.Pojo]; session-id [-639278424]

# Custom Auditing

The `java.util.logging.Handler` accepts a `java.util.logging.LogRecord` for logging. An `AuditLogRecord` is supplied by the security layer containing the `AuditDetails`. Instead of logging into a file, a custom `Handler` can capture all the log activity for auditing. By default the `java.util.logging.LogRecord.getMessage()` of `AuditLogRecord` contains the audit message (as shown in the sample output above).
