---
type: post0.3
title:  Machine Learning
categories: SPARK-XAP-003
weight: 700
---



This section describes how to reuse ML models with the Data Grid. You can train your model, save it to the Data Grid and then reuse it in different Spark contexts.

# Saving ML model to Data Grid

To save Spark MLlib midel to the Data Grid, use `saveToGrid` method on your model which extends `org.apache.spark.mllib.util.Saveable` trait.


Example:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val rdd = sc.parallelize(List(Vectors.dense(1.0, 1.0, 3.0), Vectors.dense(2.0, 0.0, 1.0), Vectors.dense(2.0, 1.0, 0.0)))
val k = 2
val maxIterations = 100
val model = KMeans.train(rdd, k, maxIterations)
model.saveToGrid(sc, "KMeansModel")
```
{{%/tab%}}
{{%/tabs%}}

# Loading ML model from Data Grid

To load an ML model from the Data Grid, use `SparkContext.loadMLModel[R]`. The type parameter `R` is an ML model class.

{{%tabs%}}
{{%tab "Scala"%}}
```scala
import com.gigaspaces.spark.mllib.implicits._
val model = sc.loadMLModel[KMeansModel]("KMeansModel").get
```
{{%/tab%}}
{{%/tabs%}}
