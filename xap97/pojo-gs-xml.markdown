---
layout: post
title:  gs - XML
categories:
parent:
weight:
---

{%comment%}
{% summary %}This section deals with the class level annotations.{% endsummary %}
{%endcomment%}

The space mapping configuration file `gs.xml` allows you to define space class metadata when using a POJO class with getter or setter methods. Space mapping files are also required when using POJO objects with the `ExternalDataSource` interface. The `gs.xml` configuration file is loaded when the application and space are started. `gs.xml` files can be edited to include GigaSpaces specific attributes.


## XML Tags

### Class Level Tags

- **`<class>`** -- a `class` and the associated Java class `ClassDescriptor` encapsulate meta data information of a concrete class.

{: .table .table-bordered}
| Attribute | Description |
|:----------|:------------|
| `name` | Contains the full qualified name of the specified class. Because this attribute is of the XML type `ID`, there can only be one `class-descriptor` per class. |
| `persist` | This field indicates the persistency mode of the object. When a space is defined as persistent, a `true` value for this attribute will persist objects of this type. {% refer %}For more details, refer to the [Persistency](./persistency.html) section. {% endrefer %} |
| `replicate` | This field indicates the replication mode of the object. When a space is defined as replicated, a `true` value for this attribute will replicate objects of this type. {% refer %}For more details, refer to the [Replication](./replication.html) section. {% endrefer %}{% wbr %}{% tip %}{% wbr %}To control replication at the object level you should specify a [replication filter](./cluster-replication-filters.html){% wbr %}{% endtip %}|
| `fifo-support` | To enable FIFO operations, set this attribute to one of the [FifoSupport](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/annotation/pojo/FifoSupport.html) enumeration values. {% refer %}For more details, refer to the [FIFO operations](./fifo-support.html) section.{% endrefer %} |

### Field Level Tags

{% tip %}
All the fields are written automatically into space. If the field is a reference to another object, it has to be Serializable and it will be written into space as well. Only the fields which need special space behavior need to be specified in the gs.xml file. Specify the fields which are id's, indexes or need exclusions, etc.
{% endtip %}

- **`<property`>** - contains mapping info for a primitive type attribute of a persistent class.

{: .table .table-bordered}
| Attribute | Description |
|:----------|:------------|
| `name` | Holds the name of the persistent class attribute. |
| `index` | Indicates which fields are indexed in the space. The first indexed member is used for hashing. Querying indexed fields speeds up read and take operations. |

- **`<reference>`** - contains mapping information for an attribute of a class that is not primitive, but references another entity object.

- **`<null-value>`** - a value that will represent a `null`. Relevant for primitive fields (int, long).

{% highlight java %}
<class name="com.j_spaces.examples.hellospacepojo.Person"
        persist="false" replicate="false">
    <property name="int_Field" null-value="-1" />
    <property name="long_Field" null-value="-1" />
</class>
{% endhighlight %}

- **`<class-ref>`** - contains the full qualified name of the specified class.
- **`<id>`** - defines whether this field value is used when generating the object ID.

{: .table .table-bordered}
| Attribute | Description |
|:----------|:------------|
| `name` | Specifies a get method that allows identification of the `id` element in the space. |
| `auto-generate` | Specifies if the object ID is generated automatically by the space when written into the space. If `false`, the field is indexed automatically, and if `true`, the field isn't indexed. |

- **`<version>`** - saves the POJO's version in the space. This must be an `int` data type field.

{: .table .table-bordered}
| Attribute | Description |
|:----------|:------------|
| `name` | Specifies a `get` method for holding the version's ID. |

- **`<persist>`** - allows you to specify whether a POJO is or isn't saved inside the space.

{: .table .table-bordered}
| Attribute | Description |
|:----------|:------------|
| `name` | Specifies a `get` method for holding the `persist` flag. |

- **`<routing>`** - Determines the target space for the operation with using partitioned space.

{: .table .table-bordered}
| Attribute | Description |
|:----------|:------------|
| `name` | Specifies a get method that allows identification of the `routing` element in the space. |

- **`<exclude>`** - causes the POJO field under this element to be excluded, and not be saved in the space.
    - If you specify a field name that exists as part of the `property` element, this field is excluded.
    - If the field name doesn't exist as part of the `property` element, this means that this field name is part of the `Person` class, and you do not want it to be saved in the space.

{% tip %}
For details about scaling a running space cluster **in runtime** see the [Dynamic Partitioning](/sbp/moving-into-production-checklist.html#Rebalancing - Dynamic Repartitioning) section.
{% endtip %}






