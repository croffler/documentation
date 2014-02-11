---
layout: post
title:  Metadata
categories: XAP97
parent: getting-started.html
weight: 600
---

{% summary %}This section deals with the annotations and gs.xml mapping file decorations.{% endsummary %}




The [GigaSpaces API](./the-gigaspace-interface.html) supports class and field-level decorations with POJOs. These can be specified via annotations on the space class source itself or external xml file accompanied with the class byte code files located within the jar/war. You can define common behavior for all class instances, and specific behavior for class fields.


{%children%}


{%comment%}

{% inittab os_simple_space|top %}
{% tabcontent Annotations %}

{% toczone minLevel=2|maxLevel=2|type=flat|separator=pipe|location=top %}

## Class Level Annotation -- @SpaceClass

{: .table .table-bordered}
| Annotation Element Name | Type | Description | Default Value |
|:------------------------|:-----|:------------|:--------------|
| `replicate` | boolean | When running in a partial replication mode, a **`false`** value for this property will not replicates all objects from this class type to the replica space or backup space. To run in a partial replication mode deploy the space cluster using the following property:{% wbr %}{% wbr %}`<os-core:space id="space" url="/./space" no-write-lease="true">`{% wbr %} `<os-core:properties>`{% wbr %}  `<props>`{% wbr %}   `<prop key="cluster-config.groups.group.repl-policy.policy-type">`{% wbr %}      `partial-replication`{% wbr %}   `</prop>`{% wbr %}  `</props>`{% wbr %} `</os-core:properties>`{% wbr %}`</os-core:space>`{% wbr %}. {% wbr %}{% wbr %}To control replication at the object level you should specify a [replication filter](./cluster-replication-filters.html){% wbr %}{% wbr %}| `true` |
| `persist` | boolean | When a space is defined as persistent, a `true` value for this annotation persists objects of this type. {% refer %}For more details, refer to the [Persistency](./persistency.html) section.{% endrefer %} | `true` |
| `fifoSupport` | enum of `FifoSupport` | To enable FIFO operations, set this attribute to `FifoSupport.OPERATION`. {% refer %}For more details, refer to the [FIFO operations](./fifo-support.html) section.{% endrefer %} | `FifoSupport.NOT_SET` |
| `includeProperties` | String | `IncludeProperties.IMPLICIT` takes into account all POJO fields -- even if a `get` method is not declared with a `@SpaceProperty` annotation, it is taken into account as a space field.{% wbr %}`IncludeProperties.EXPLICIT` takes into account only the `get` methods which are declared with a `@SpaceProperty` annotation. | `IMPLICIT` |
| `inheritIndexes` | `boolean` | Whether to use the class indexes list only, or to also include the superclass' indexes. {% wbr %}If the class does not define indexes, superclass indexes are used. {% wbr %}Options:{% wbr %}- `false` -- class indexes only.{% wbr %}- `true` -- class indexes and superclass indexes. | `true` |
| `storageType` | enum of `StorageType` | To determine a default storage type for each non primitive property for which a (field level) storage type was not defined.{% wbr %}{% refer %}For more details, refer to the [Storage Types - Controlling Serialization](./storage-types---controlling-serialization.html) section.{% endrefer %} | `StorageType.OBJECT` |

## Field Level Annotation -- @SpaceProperty

{: .table .table-bordered}
| Element | Type | Description | Default Value |
|:--------|:-----|:------------|:--------------|
| `nullValue` | String | Specifies that a value be treated as `null`. | |

example:

{% highlight java %}
@SpaceProperty(nullValue="-1" )
public int getEmployeeID()
{
	return employeeID;
}
{% endhighlight %}

where `-1` functions as a `null` value.

## Field Level Decoration -- @SpaceId

The space mapping file element name for `@SpaceId` is `id` (see [below](#1)).

Defines whether this field value is used when generating the Object ID. The field value should be unique -- i.e., no multiple objects with the same value should be written into the space (each object should have a different field value). When writing an object into the space with an existing `id` field value, an `EntryAlreadyInSpaceException` is thrown. The Object ID is created, based on the `id` field value.

{% warning %}
 The `@SpaceID` annotation cannot be used with multiple fields. You may specify only **one** field to be used as the `@SpaceId` field.
{% endwarning %}

If `autoGenerate` is declared as `false`, the field is indexed automatically. If `autoGenerate` is declared as `true`, the field isn't indexed.
If `autoGenerate` is `true`, the field must be of the type `java.lang.String`.

{: .table .table-bordered}
| Element | Type | Description | Default Value |
|:--------|:-----|:------------|:--------------|
| `autoGenerate` | boolean | Specifies if the object ID is generated automatically by the space when written into the space. If `false`, the field is indexed automatically, and if `true`, the field isn't indexed | `false` |

{% refer %}For more details, see the [Space Object ID Operations](./space-object-id-operations.html) section.{% endrefer %}

## Field Level Decoration -- @SpaceIndex

Querying indexed fields speeds up read and take operations. The `@SpaceIndex` annotation should be used to specify an indexed field. The `@SpaceIndex` has two attributes:**type** and **path**.

- The index type is determined by the `SpaceIndexType` enumeration. This is a mandatory attribute when using the `@SpaceIndex` annotation. The index types options are:
    - BASIC - This index speeds up equality matches (equal to/not equal to).
    - EXTENDED - This index speeds up comparison matches (bigger than/less than).
    - NONE - Indicates no index type is set, and default should be used.
- The `path()` attribute represents the path of the indexed property within a nested object.

Examples:

{% highlight java %}
@SpaceClass
public class Person
{
    private String lastName;
    private String firstName;
    private Integer age;

    ...
    @SpaceIndex(type=SpaceIndexType.BASIC)
    public String getFirstName() {return firstName;}
    public void setFirstName(String firstName) {this.firstName = firstName;}

    @SpaceIndex(type=SpaceIndexType.EXTENDED)
    public String getAge() {return age;}
    public void setAge(String age) {this.age = age;}
}
{% endhighlight %}

{% highlight java %}
@SpaceClass
public static class Person {
    private int id;
    private Info personalInfo;
    private String description;
    //getter and setter methods
    ...

    // this defines and EXTENDED index on the personalInfo.socialSecurity property
    @SpaceIndex(path = "socialSecurity", type = SpaceIndexType.EXTENDED)
    public Info getPersonalInfo() {
         return personalInfo;
    }
}

public static class Info implements Serializable {
	private String name;
	private Date birthday;
	private long socialSecurity;
	//getter and setter methods
}
{% endhighlight %}

{% exclamation %} See the [Indexing](./indexing.html) section for details.

{% note %}
It is highly recommended to index fields used for matching/query. Without the proper index (BASIC or EXTENDED ), the read/readMultiple/take/takeMultiple operations response time might be affected.
{% endnote %}

## Field Level Decoration -- @SpaceVersion

This specifies a get method for holding the version ID. This field should be an `int` data type.

{% exclamation %} The `@SpaceVersion` must be an `int` data type.

## Field Level Decoration - @SpacePersist

This specifies a getter method for holding the persistency mode of the object overriding the class level `persist` declaration. This field should be of the `boolean` data type.
If the `persist` class level annotation is `true`, all objects of this class type will be persisted into the underlying data store (Mirror, ExternalDataSource, Storage Adapter).

{% tip %}
When using this option, you must have the space class level `persist` decoration specified.
{% endtip %}

## Field Level Decoration - @SpaceRouting

The `@SpaceRouting` annotation specifies a get method for the field to be used to calculate the target space for the space operation (read , write...). The `@SpaceRouting` field value hash code is used to calculate the target space when the space is running in **partitioned mode**.
See more details at the [Data-Partitioning](./data-partitioning.html) section.

{% tip %}
For details about scaling a running space cluster **in runtime** see the [Elastic Processing Unit](./elastic-processing-unit.html) section.
{% endtip %}

{% anchor SpaceLeaseExpiration %}

## Field Level Decoration - @SpaceLeaseExpiration

The `@SpaceLeaseExpiration` annotation specifies a get and a set method for holding the timestamp of when the instance's lease expires (this is a standard Java timestamp based on the 1/1/1970 epoch). This property should not be populated by the user code. The space will populate this property automatically based on the lease time given by the user when writing the object.
When using an external data source, you can choose to persist this value to the database. Subsequently, when data is reloaded from the external data source (at startup time for example), the space will filter out instances whose lease expiration timestamp has already passed. This field should be a `long` data type.

Here is how you can load an object into the space via the External Data source with a specific lease:
Have the `@SpaceLeaseExpiration` decoration on a getter method for a field that will hold the object lease. Usually this will be set by GigaSpaces , but when loading the object you will set it yourself.

{% highlight java %}
@SpaceClass (persist=true)
public class MyData {
    private long lease;
	.............

    @SpaceLeaseExpiration
    public long getLease()
    {
        return lease;
    }
    public void setLease(long lease) {
        this.lease = lease;
    }
}
{% endhighlight %}

when loading the object into the space via the External Data source you should set this field lease value - with the example below the loaded object lease will be 10 seconds:

{% highlight java %}
public DataIterator<MyData> initialLoad() throws DataSourceException {
    List<MyData> initData = new ArrayList<MyData>();
    // load the space with some data
    MyData obj = new MyData();
    obj.setWhatEver(...);
    obj.setLease(System.currentTimeMillis() + 10000);
    initData.add(obj);
    return new MyDataIterator(initData);
}
{% endhighlight %}

Once an object has been loaded/written into the space you can also change the lease using the `Gigaspace. write(T entry, long lease, long timeout, int modifiers)` method.

## Field Level Decoration - @SpaceExclude

The `@SpaceExclude` annotation instructs the client to ignore the fields using this annotation, so that they are not stored within the space.

- When `IncludeProperties` is defined as `IMPLICIT` as part of the [@SpaceClass annotation](#1), `@SpaceExclude` should usually be used. This is because `IMPLICIT` instructs the system to take all POJO fields into account.
- When `IncludeProperties` is defined as `EXPLICIT`, there is no need to use `@SpaceExclude`.
- `@SpaceExclude` can still be used, even if `IncludeProperties` is not defined.

## Field Level Decoration -- @SpaceStorageType

The `@SpaceStorageType` annotation should be used to specify how the property is stored in the space.
The `@SpaceStorageType` has one attribute- **storageType**.
**The storage type options are:**

- `OBJECT` - The property is stored in the space using its Java serialization method.
This is the only type that enables to query the property or to index it,
and is the only type that can be declared on primitive properties.
This is also the default type.

- `BINARY` - The property is stored in the space in its serialized form, reducing serialize and de-serialize operations.

- `COMPRESSED` - The property is compressed before being transferred into the space and is stored within the space in the compressed mode, reducing foot-print.

{% refer %}For more details and examples, refer to the [Storage Types - Controlling Serialization](./storage-types---controlling-serialization.html) section.{% endrefer %}

## Field Level Decoration -- @SpaceFifoGroupingProperty

The `@SpaceFifoGroupingProperty` annotation should be used to define a space FIFO grouping property.
If defined, the `TakeModifiers.FIFO_GROUPING_POLL` or `ReadModifiers.FIFO_GROUPING_POLL` modifiers can be used to return
all space entries that match the selection template in FIFO order.
Different values of the FG property define groups of space entries that match each value -
FIFO ordering exists within each group and not between different groups.

{% refer %}For more details and examples, refer to the [FIFO Grouping](./fifo-grouping.html) section.{% endrefer %}

## Field Level Decoration -- @SpaceFifoGroupingIndex

The `@SpaceFifoGroupingIndex` annotation should be used to define a space FIFO grouping Index.
Can be declared on several properties in a class in order to assist in efficient traversal.
If defined, there must be a property in the class, marked with the `@SpaceFifoGroupingProperty` annotation.
A compound index that contains this FIFO grouping index and the FIFO grouping property will be created.

{% refer %}For more details and examples, refer to the [FIFO Grouping](./fifo-grouping.html) section.{% endrefer %}

{% anchor SpaceClassConstructor %}
## Constructor Level Decoration -- @SpaceClassConstructor

The `@SpaceClassConstructor` annotation can be placed on a POJO constructor to denote that this constructor should be used during object instantiation.
Using this annotations, it is possible for the POJO to have immutable properties (i.e. `final` fields).
As opposed to a standard POJO, a POJO annotated with this annotation may omit setters for its properties.
Except for the case where the id property is auto generated, only properties defined in this constructor will be considered space properties.
The annotations can be placed on at most one constructor.

{% highlight java %}
public class Data {
    private final Integer id;
    private final String data;

    @SpaceClassConstructor
    public Data(Integer id, String data) {
        this.id = id;
        this.data = data;
    }

    @SpaceId
    public Integer getId() {
	return id;
    }

    public String getData() {
	return data;
    }

    // notice that the lack of setters for id and data is this case is valid
}
{% endhighlight %}

## POJO Class Example -- Person and Employee

This example uses the `@SpaceId`, `@SpaceRouting`, `@SpaceClass`, `replicate`, `persist`, `@SpaceVersion`, `@SpaceProperty` and `SpaceIndex` annotations as part of the `Person` and `Employee` classes:

{% highlight java %}
package com.j_spaces.examples.hellospacepojo;
import com.gigaspaces.annotation.pojo.*;

@SpaceClass(replicate=true,persist=false)
public class Person {
    private String	lastName;
    private String	firstName;
    public Person(){}
    public Person(String lastName, String firstName){
        this.lastName = lastName;
        this.firstName = firstName;
    }
    @SpaceIndex(type=SpaceIndexType.BASIC)
    public String getFirstName(){return firstName;}
    public void setFirstName(String firstName)
          {this.firstName = firstName;}
    public String getLastName(){return lastName;}
    public void setLastName(String name) {this.lastName = name;}
}
{% endhighlight %}

{% highlight java %}
package com.j_spaces.examples.hellospacepojo;

import com.gigaspaces.annotation.pojo.SpaceClass;
import com.gigaspaces.annotation.pojo.SpaceId;
import com.gigaspaces.annotation.pojo.SpaceRouting;
import com.gigaspaces.annotation.pojo.SpaceVersion;

@SpaceClass(replicate=true,persist=false)
public class Employee extends Person
{
    private Integer employeeID;
    private int versionID;

    public Employee(){}
    public Employee(Integer employeeID) {
        this.employeeID = employeeID;
    }
    public Employee(String lastName, Integer employeeID) {
        this.employeeID = employeeID;
        setLastName(lastName);
    }

    @SpaceId
    @SpaceRouting
    public Integer getEmployeeID(){return employeeID;}

    public void setEmployeeID(Integer employeeID) {
        this.employeeID = employeeID;
    }
    public String toString() {
        return super.toString() + ", \temployeeID: "+ employeeID ;
    }

    @SpaceVersion
    public int getVersionID() {return versionID;}
    public void setVersionID(int versionID) {this.versionID = versionID;}
}
{% endhighlight %}

{% endtoczone %}

{% endtabcontent %}

{% tabcontent Space Mapping XML File -- gs.xml %}

The space mapping configuration file `gs.xml` allows you to define space class metadata when using a POJO class with getter or setter methods. Space mapping files are also required when using POJO objects with the `ExternalDataSource` interface. The `gs.xml` configuration file is loaded when the application and space are started. `gs.xml` files can be edited to include GigaSpaces specific attributes.

{% toczone minLevel=2|maxLevel=2|type=flat|separator=pipe|location=top %}

## gs.xml Location

The `\*.gs.xml` file should reside in same location as the related Pojo:
the `gs.xml` file should use the same class name as the file prefix. For example, if a POJO class is located at "mpApp/my/package/MyPojo.class" then the mapping file should also be located at "mpApp/my/package/MyPojo.gs.xml".

{% exclamation %} The `replicate` and `persist` attributes **must** be defined (either `true` or `false`), as part of the `class` element.

## gs.xml Example

When using the `version`, `id` and `routing` elements, place these in the `gs.xml` file in the following order:

1. `version`
1. `id`
1. `routing`

Below is an example for an `Employee` class and a `Person` class XML configuration file named `mapping.gs.xml`:

{% highlight xml %}
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE gigaspaces-mapping PUBLIC "-//GIGASPACES//DTD GS//EN"
    "http://www.gigaspaces.com/dtd/7_1/gigaspaces-metadata.dtd">
<gigaspaces-mapping>
    <class name="com.j_spaces.examples.hellospacepojo.Employee" persist="true" replicate="true">
        <version name="versionID" />
        <id name="employeeID" auto-generate="false" />
        <routing name="employeeID" />
        <reference
            class-ref="com.j_spaces.examples.hellospacepojo.Person" />
    </class>
    <class name="com.j_spaces.examples.hellospacepojo.Person" persist="true" replicate="true">
        <property name="lastName" index="BASIC" />
        <property name="firstName" index="BASIC" />
    </class>
</gigaspaces-mapping>
{% endhighlight %}

The corresponding `Employee` class and a `Person` would be:

{% highlight java %}
public class Person
{
	private String	lastName; 	private String	firstName;
	public Person(){}
	public Person(String lastName, String firstName)
	{
		this.lastName = lastName;
		this.firstName = firstName;
	}

	private String getFirstName(){	return firstName;}
	public void setFirstName(String firstName){this.firstName = firstName;}

	private String getLastName(){return lastName;}
	public void setLastName(String name){ this.lastName = name;}
}
{% endhighlight %}

{% highlight java %}
public class Employee extends Person
{
	private Integer	employeeID;
	private int versionID;
	public Employee(){}

	public Employee(Integer employeeID)
	{
		this.employeeID = employeeID;
	}

	public Employee(String lastName, Integer employeeID)
	{
		this.employeeID = employeeID;
		setLastName(lastName);
	}

	private Integer getEmployeeID(){	return employeeID;	}
	private void setEmployeeID(Integer employeeID)	{this.employeeID = employeeID;}

	private int getVersionID(){	return versionID;	}
	private void setVersionID(Integer versionID)	{this.versionID= versionID;}
}
{% endhighlight %}

{% note %}
The Employee class uses the <reference> tag to inherit metadata from the Person Class.
{% endnote %}

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

{% endtoczone %}

{% endtabcontent %}
{% endinittab %}




# User Defined Space Class Fields

You may have user defined data types (non-primitive data types) with your Space class. These should implement the `Serializable` or `Externalizable` interface. The user defined class nested fields can be used with queries and can be indexed. See the [Nested Properties](./sqlquery.html#Nested Properties) and the [Nested Properties Indexing](./indexing.html#Nested Properties Indexing) section for details.


{%endcomment%}

# Troubleshooting

## Logging

Use the `com.gigaspaces.pojo.level = ALL` as part of the logging file located by default at `<GigaSpaces Root>\config\gs_logging.properties`, to debug the POJO metadata load and conversion to space object. Having the `<GigaSpaces Root>` as part of the application `CLASSPATH` turns on the POJO debug activity at the client side.

When the POJO logging is turned on, the following should appear at the client side console when a class is introduced to the space:

{% highlight java %}
FINEST [com.gigaspaces.pojo]: The annotation structure of class com.j_spaces.examples.hellospacepojo.Employee is :
name = com.j_spaces.examples.hellospacepojo.Employee
fieldNames = [firstName, lastName, employeeID, versionID]
fieldPks = [employeeID]
fieldAutoPkGen = []
fieldIndexs = [employeeID, firstName, lastName]
hashBasedKey = []
version = [versionID]
lazyDeserialization = []
payload = []
serializationTypeFields = {}
defaultNullValueFields = {firstName=null, lastName=null}
refClasses = [com.j_spaces.examples.hellospacepojo.Person]
persist class = false
persist instance = []
routing field name = [employeeID]
timetolive = 9223372036854775807
fifo = false
inheritIndexes = true
includeProperties = IMPLICIT
replicate true
fieldTypes = null
mappingType = space
serializationType = 0
exclude = []
{% endhighlight %}

A converted object logging output looks like this:

{% highlight java %}
FINE [com.gigaspaces.pojo]: ExternalEntry after converter is:
	 ClassName: com.j_spaces.examples.hellospacepojo.Employee

	 Field Name:  firstName
	 Field Type:  java.lang.String
	 Field Value: first name1
	 Field Indexed: false

	 Field Name:  lastName
	 Field Type:  java.lang.String

	 Field Value: Last Name1
	 Field Indexed: false

	 Field Name:  employeeID
	 Field Type:  java.lang.Integer
	 Field Value: 1
	 Field Indexed: true
{% endhighlight %}

## Using The GUI

Use the GS-UI [Data Types View](./data-types-view---gigaspaces-browser.html) to examine the POJO meta data. Make sure the annotations/xml decorations have been introduced to the space correctly i.e. correct class name, field names, field types, indexes, routing field, replication mode and FIFO mode etc.
