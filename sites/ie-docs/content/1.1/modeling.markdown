---
type: post1.1
title:  Data Modeling
categories: SPARK-XAP-011
weight: 400
---


This section describes how to define the Data Grid model.


# Class annotations

Natively the Data Grid supports Java POJO's as model classes. Model classes should be annotated with the Data Grid specific annotations.

To define model classes in Scala:

* create a case class and annotate its properties with `scala.beans.BeanProperty` and the Data Grid specific annotations from `org.insightedge.scala.annotation`
* class should have a public no-args constructor
* all properties should be defined as `var` (future releases will support immutable case classes)

Here is an example of `Product` class:

{{%tabs%}}
{{%tab "Scala" %}}
```scala
import org.insightedge.scala.annotation._
import scala.beans.{BeanProperty, BooleanBeanProperty}

case class Product(

   @BeanProperty
   @SpaceId
   var id: Long,

   @BeanProperty
   var description: String,

   @BeanProperty
   var quantity: Int

) {
   def this() = this(-1, null, -1)
}
```
{{%/tab%}}
{{%/tabs%}}

If you want to increment the `id` property automatically when saving to the data grid, use `@SpaceId(autoGenerate = true)` (only for `String` fields).

{{%note "Indexing"%}}
You can improve the speed of data filtering and retrieval operations by defining indexes. The `@SpaceIndex` annotation is used to index properties on the
POJO that is used to interact with the Data Grid.
{{%/note%}}

{{%note "Controlling Spark partitions"%}}
By default there is a one-to-one mapping between Spark and Data Grid partitions. If you want your RDD or DataFrame to have more partitions than Data Grid, you have to mixin `org.insightedge.spark.model.BucketedGridModel` trait into your class.
The `BucketedGridModel.metaBucketId` property should be uniformly distributed between 0 and 128.
{{%/note%}}