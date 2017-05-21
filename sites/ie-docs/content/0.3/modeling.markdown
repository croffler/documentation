---
type: post0.3
title:  Data Modeling
categories: SPARK-XAP-003
weight: 400
---


This section describes how to define the Data Grid model.

# Class annotations

Natively the Data Grid supports POJO's as model classes. Model classes should be annotated with the Data Grid specific annotations.

To define model classes in Scala:

* create a case class and annotate its properties with `scala.beans.BeanProperty` and the Data Grid specific annotations from `com.gigaspaces.scala.annotation`
* class should have a public no-args constructor
* case class should mixin `GridModel` trait
* all properties should be defined as `var` (future releases will support immutable case classes)

Here is an example of `Product` class:

{{%tabs%}}
{{%tab "Scala" %}}
```scala
import com.gigaspaces.scala.annotation._
import com.gigaspaces.spark.model.GridModel
import scala.beans.{BeanProperty, BooleanBeanProperty}

case class Product(

   @BeanProperty
   @SpaceId
   var id: Long,

   @BeanProperty
   var description: String,

   @BeanProperty
   var quantity: Int

) extends GridModel {
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