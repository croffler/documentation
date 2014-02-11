---
layout: post
title:  Advanced Scripts
categories: XAP97
parent: scripts.html
weight: 100
---


{% summary page%}Overview of the additional scripts included in `<gigaspaces root>/bin/advanced-scripts.zip`{% endsummary %}

# Overview 
In addition to the scripts described [here](./scripts.html), the `bin` folder contains **advanced_scripts.zip** for additional tasks, usually for development and troubleshooting 

# Service Grid Scripts 

If you need to start the [Service Grid](./service-grid.html) components manually instead of via the [gs-agent](./service-grid.html#gsa), use the following scripts:
 
- **startJiniLUS** - starts an instance of the [LUS](./service-grid.html#lus). 
- **gsc** - starts an instance of the [GSC](./service-grid.html#gsc). 
- **gsm** - starts an instance of the [GSM](./service-grid.html#gsm) and [LUS](./service-grid.html#lus). 
- **gsm_nolus** - starts an instance of the [GSM](./service-grid.html#gsm). 
- **esm** - starts an instance of the [ESM](./elastic-processing-unit.html). 
- **startJiniTX_Mahalo** - starts an instance of the Distributed transaction manager. 

# Processing Units 
- **puInstance** - starts a standalone, unmanaged instance of a processing unit. 
- **gsInstance** - starts a standalone, unmanaged instance of a space. Used usually in development. For more info see [here](./scripts-gsinstance.html). 
- **gs-memcached** - starts standalone, unmanaged instance of [Memcached API](./memcached-api.html) listener. 

# Misc 
- **lookupbrowser** - Used with for special debug scenarios to inspect the lookup service. 
- **platform-info** - prints GigaSpaces version info (Use the command line [version](./command-line-interface.html) instead).
