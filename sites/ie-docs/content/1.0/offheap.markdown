---
type: post1.0
title:  Off-Heap persistence
categories: SPARK-XAP-010
weight: 900
---


One of the most important capabilities in Spark is persisting (or caching) datasets in memory across operations. Each persisted RDD can be stored using a different *storage level*.
One of the possibilities is to store RDDs in serialized format off-heap.
Compared to storing data in the Spark JVM, off-heap storage reduces garbage collection overhead and allows executors to be smaller and to share a pool of memory.
This makes it attractive in environments with large heaps or multiple concurrent applications.

{{%refer%}}
Please refer to [Spark documentation](http://spark.apache.org/docs/latest/programming-guide.html#rdd-persistence) for more details.
{{%/refer%}}

InsightEdge provides the capability to store RDD off-heap in the Data Grid.


# Off-Heap configuration

To configure Data Grid Off-Heap persistence, set `SparkConf`'s `spark.externalBlockStore.blockManager` property to `org.apache.spark.storage.GigaSpacesBlockManager`:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val sparkConf = new SparkConf()
  .setAppName("OffHeapPersistence")
  .setMaster(master)
  .setGigaSpaceConfig(gsConfig)
  .set("spark.externalBlockStore.blockManager", "org.apache.spark.storage.GigaSpacesBlockManager")
```
{{%/tab%}}
{{%/tabs%}}

# RDD persistence

To persist RDDs with `OFF_HEAP` storage level, you can use the regular Spark API:

{{%tabs%}}
{{%tab "Scala"%}}
```scala
val sc = new SparkContext(sparkConf)

val rdd = sc.parallelize((1 to 10).map { i =>
  Product(i, "Description of product " + i, Random.nextInt(10), Random.nextBoolean())
})

rdd.persist(StorageLevel.OFF_HEAP)
```
{{%/tab%}}
{{%/tabs%}}

