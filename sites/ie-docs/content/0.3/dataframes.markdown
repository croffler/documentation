---
type: post0.3
title:  Data Frames API
categories: 10SPARK-XAP-003
weight: 600
---


This section describes how to use the DataFrames API with the the Data Grid.

# Reading Data Grid objects as Spark DataFrame

To read Data Grid objects as a Spark DataFrame, use `SparkContext.gridDataFrame()`.

For example:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val df = sc.gridDataFrame[Product]()
df.printSchema()
val count = df.filter(df("quantity") < 5).count()
println("DataFrame count = " + count)
```
{{%/tab%}}
{{%/tabs%}}

# Executing SQL query using Spark

If you prefer SQL over DataFrame DSL, you can register dataframes as a temporary table and execute SQL queries against it:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val df = sc.gridDataFrame[Product]()
df.registerTempTable("product")
val r = sc.gridSqlContext.sql("SELECT * FROM product WHERE quantity < 5")
```
{{%/tab%}}
{{%/tabs%}}

# Pre-selecting data with Data Grid SQL Query

If you need to load only a subset of Data Grid objects, use `SparkContext.gridSqlDataFrame()`.

For example:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val df = sc.gridSqlDataFrame[Product]("quantity < 5")
```
{{%/tab%}}
{{%/tabs%}}

{{%note%}}
In contrast to previous example a dataset is filtered on the Data Grid side rather than on Spark side. This is useful when you want to leverage the Data Grid indexes to efficiently load a subset of objects from the Data Grid.
{{%/note%}}

