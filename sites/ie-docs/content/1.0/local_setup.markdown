---
type: post1.0
title:  Local Machine Setup
categories: SPARK-XAP-010
weight: 1000
---


In this tutorial, you will learn how to install and run InsightEdge on a local machine.


# Installation

The InsightEdge environment consists of Spark and the Data Grid. You have two options to run InsightEdge locally.

{{%warning%}}
Currently, only demo mode is available for Windows. This mode runs local Spark and Datagrid cluster, which is enough for most dev environments. Starting `demo` mode on Windows described in [Quick Start Guide](quick_start.html).
{{%/warning%}} 

The first option is to start the full InsightEdge environment:

* Spark `master` and `worker`
* Data Grid `manager` and `node`
* Data Grid with `empty space`
* Spark WebUI will be available at `http://127.0.0.1:8080`
* Spark Master connection endpoint will be at `spark://127.0.0.1:7077`

{{%tabs%}}
{{%tab Community%}}
```bash
./sbin/insightedge.sh --mode master --master 127.0.0.1
./sbin/insightedge.sh --mode slave --master 127.0.0.1
```
{{%/tab%}}
{{%tab Premium%}}
```bash
./sbin/insightedge.sh --mode master --master 127.0.0.1
./sbin/insightedge.sh --mode slave --master 127.0.0.1
./sbin/insightedge.sh --mode deploy --master 127.0.0.1
```
{{%/tab%}}
{{%/tabs%}}

The second option is to start a Data Grid and use local mode to run Spark applications:

{{%tabs%}}
{{%tab Community%}}
```bash
./sbin/start-datagrid-master.sh --master 127.0.0.1
./sbin/start-datagrid-slave.sh --master 127.0.0.1
```
{{%/tab%}}
{{%tab Premium%}}

```bash
./sbin/start-datagrid-master.sh --master 127.0.0.1
./sbin/start-datagrid-slave.sh --master 127.0.0.1
./sbin/deploy-datagrid.sh --master 127.0.0.1
```
{{%/tab%}}
{{%/tabs%}}

When you run your applications using this option, you should specify `local[*]` instead of the Spark master url.

Both options run the Data Grid with default configuration:

{{%tabs%}}
{{%tab Community%}}
* Data Grid lookup locator is `127.0.0.1:4174` (lookup service is started on `4174` port)
* Data Grid lookup group is `insightedge`
* Data Grid has `insightedge-space` space as standalone processes with `2,0` topology (`2 primary` and `0 backup` partitions, `1G` heap each)
{{%/tab%}}
{{%tab Premium%}}
* Data Grid consists of manager and 2 containers (`1G` heap each)
* Data Grid lookup locator is `127.0.0.1:4174` (lookup service is started on `4174` port)
* Data Grid lookup group is `insightedge`
* Data Grid has `insightedge-space` deployed on it with `2,0` topology (`2 primary` and `0 backup` partitions)
{{%/tab%}}
{{%/tabs%}}


# Restarting or stopping local environment

The simplest way to restart the local environment is to use `insightedge.sh` script:

{{%tabs%}}
{{%tab Community%}}
```bash
./sbin/insightedge.sh --mode master --master 127.0.0.1
./sbin/insightedge.sh --mode slave --master 127.0.0.1
```
{{%/tab%}}
{{%tab Premium%}}

```bash
./sbin/insightedge.sh --mode undeploy --master 127.0.0.1
./sbin/insightedge.sh --mode master --master 127.0.0.1
./sbin/insightedge.sh --mode slave --master 127.0.0.1
./sbin/insightedge.sh --mode deploy --master 127.0.0.1
```
{{%/tab%}}
{{%/tabs%}}


If necessary, the `master` and `slave` modes will stop the currently running components and start new ones.

To stop the environment, you can use `shutdown` mode:

{{%tabs%}}
{{%tab Linux%}}
```bash
./sbin/insightedge.sh --mode shutdown
```
{{%/tab%}}

{{%tab Windows%}}
```bash
sbin\insightedge.cmd --mode shutdown
```
{{%/tab%}}
{{%/tabs%}}

Alternatively, you can execute the following component-specific scripts:

{{%tabs%}}
{{%tab Community%}}
```bash
./sbin/stop-master.sh
./sbin/stop-slave.sh
./sbin/stop-datagrid-master.sh
./sbin/stop-datagrid-slave.sh
```
{{%/tab%}}
{{%tab Premium%}}
```bash
./sbin/undeploy-datagrid.sh --master 127.0.0.1
./sbin/stop-master.sh
./sbin/stop-slave.sh
./sbin/stop-datagrid-master.sh
./sbin/stop-datagrid-slave.sh
```

You can skip `undeploy-datagrid.sh` if you just want to stop everything.
{{%/tab%}}
{{%/tabs%}}


# Running demo

You can run the entire local environment in this mode, which will start the `Web Notebook` in addition to the other components mentioned previously:

{{%tabs%}}
{{%tab Linux%}}
```bash
./sbin/insightedge.sh --mode demo
```
{{%/tab%}}

{{%tab Windows%}}
```bash
sbin\insightedge.cmd --mode demo
```
{{%/tab%}}
{{%/tabs%}}

{{%refer%}}
For more details on the demo mode refer to [Interactive web notebook](./notebook.html).
{{%/refer%}}
