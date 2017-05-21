---
type: post1.0
title:  Connecting to The Grid
categories: SPARK-XAP-010
weight: 300
---


This section describes how to connect your Spark application to the Data Grid.


# Creating the GigaSpacesConfig

To connect the Spark application to the Data Grid, use `import org.insightedge.spark.implicits.all._` to enable the Spark-to-DataGrid specific API and configure `SparkConf` with the `GigaSpacesConfig` object:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
import org.insightedge.spark.context.GigaSpacesConfig
import org.insightedge.spark.implicits.all._

val gsConfig = GigaSpacesConfig("insightedge-space", Some("insightedge"), Some("127.0.0.1:4174"))

val sparkConf = new SparkConf().setAppName("sample-app").setMaster("spark://127.0.0.1:7077").setGigaSpaceConfig(gsConfig)
```
{{%/tab%}}
{{%/tabs%}}

In this example we connect to a Space `insightedge-space` with a lookup group `insightedge` and a lookup locator `127.0.0.1:4174`.

Supported `GigaSpacesConfig` parameters are listed in the table below:

| Property Name | Description                                                                                                                                      |
|:--------------|:-------------------------------------------------------------------------------------------------------------------------------------------------|
|spaceName      |Space name. Defines the logical namespace for Data Grid objects. When starting InsightEdge in a demo mode the name of space is `insightedge-space`|
|lookupGroups   |Space lookup groups. Used to locate the space with multicast discovery. In a demo mode the group is `insightedge`                                 |
|lookupLocators |Space lookup locators. Used to locate the space with unicast discovery. In a demo mode the locator is `127.0.0.1:4174`                            |


# Creating the SparkContext

Create `SparkContext` as you usually do with a pure Spark application:
{{%tabs%}}
{{%tab "Scala" %}}
```scala
val sc = new SparkContext(sparkConf)
```
{{%/tab%}}
{{%/tabs%}}

Now you are all set and can start using the `SparkContext` with the extended functionality.


# Closing the SparkContext

When you are done interacting with the `SparkContext`, close it and all connections to Data Grid with:

{{%tabs%}}
{{%tab "Scala" %}}
```scala
sc.stopGigaSpacesContext()
```
{{%/tab%}}
{{%/tabs%}}

Under the hood it will call regular Spark's `sc.stop()`, so there is no need to call it manually.


{{%refer%}}
For details on creating `SparkContext` please refer to [Initializing Spark](http://spark.apache.org/docs/latest/programming-guide.html#initializing-spark).
{{%/refer%}}
