---
type: post0.3
title:  RDD API
categories: SPARK-XAP-003
weight: 500
---




This section describes how to load data from the Data Grid to Spark.

# Creating the Data Grid RDD

To load data from the Data Grid, use `SparkContext.gridRdd[R]`. The type parameter `R` is a Data Grid model class. For example,

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val products = sc.gridRdd[Product]()
```
{{%/tab%}}
{{%/tabs%}}

Once RDD is created, you can perform any generic Spark actions or transformations, e.g.

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val products = sc.gridRdd[Product]()
println(products.count())
println(products.map(_.quantity).sum())
```
{{%/tab%}}
{{%/tabs%}}

# RDD.saveToGrid method

To save Spark RDD to the Data Grid, use `RDD.saveToGrid` method. It assumes that type parameter `T` of your `RDD[T]` is a Space class otherwise an exception will be thrown at runtime.

Example:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val products = (1 to 1000).map(i => Product(i, "Description of product " + i, Random.nextInt(10), Random.nextBoolean()))
val rdd = sc.parallelize(products)
rdd.saveToGrid()
```
{{%/tab%}}
{{%/tabs%}}

# Grid-side RDD filters

To query a subset of data from the Data Grid, use the `SparkContext.gridSql[R](sqlQuery, args)` method. The type parameter `R` is a Data Grid model class, the `sqlQuery`parameter is a native Data Grid SQL query, `args` are arguments for the SQL query. For example, to load only products with a quantity more than 10:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val products = sc.gridSql[Product]("quantity > 10")
```
{{%/tab%}}
{{%/tabs%}}


You can also bind parameters in the SQL query:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val products = sc.gridSql("quantity > ? and featuredProduct = ?", Seq(10, true))
```
{{%/tab%}}
{{%/tabs%}}

For more details on Data Grid SQL queries please refer to [Data Grid documentation](http://docs.gigaspaces.com/xap102/query-sql.html).

