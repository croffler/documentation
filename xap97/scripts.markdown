---
layout: post
title:  Scripts
categories: XAP97
parent: managing-and-monitoring-a-running-system.html
weight: 100
---

{% summary page%}Overview of the scripts included in the {{<gigaspaces root>/bin}} folder{% endsummary %}

The `<gigaspaces root>/bin` folder includes scripts to manage and monitor [GigaSpaces Runtime](./the-runtime-environment.html) Components and Applications:

- **setenv** - Used by all scripts to configure and load [Common Environment Variables](./common-environment-variables.html).
- **gs** - starts the GigaSpaces [interactive shell](./command-line-interface.html).
- **gs-ui** - starts the [GigaSpaces Management Center](./gigaspaces-management-center.html).
- **gs-webui** - starts the [Web Management Console](./web-management-console.html).
- **gs-agent** - Starts the [GigaSpaces runtime environment](./the-runtime-environment.html) via the [Grid Service Agent](./service-grid.html#gsa) (GSA), which starts and manages the [Service Grid](./service-grid.html) components.

{%note%} The `bin` folder also contains `advanced_scripts.zip` which contains [additional scripts](./advanced-scripts.html) occasionally useful for development and troubleshooting purposes.
{%endnote%}