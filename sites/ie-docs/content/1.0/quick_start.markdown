---
type: post1.0
title:  Quick Start Guide
categories: SPARK-XAP-010
weight: 100
---


In this tutorial, you will learn how to start InsightEdge and run examples locally. You can download the latest InsightEdge distribution from [here](http://insightedge.io/#download) and unpack it to any location.


# Starting InsightEdge

The InsightEdge cluster consists of Spark and a Data Grid. To start the minimum cluster locally, run the following command:

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


This will start Spark, the Data Grid and an interactive Web Notebook:

* Spark Master web ui is running at `http://127.0.0.1:8080`
* Web Notebook is running at `http://127.0.0.1:8090`

# Running the examples

Open the web notebook at `http://127.0.0.1:8090` and run any of the available examples.

{{%align center%}}
![image](/docs/attachment_files/Zeppelin_examples_100.png)
{{%/align%}}

After you are done with examples, you can shutdown local environment with next command:

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
