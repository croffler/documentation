---
layout: post
title:  Attribute Metadata
categories: XAP97
parent: pojo-metadata.html
weight: 200
---

{% summary %}This section explains the different attribute metadata .{% endsummary %}

{%wbr%}

Specific behavior for class attributes can be defined with annotations. The annotations are defined on the getter methods.


# SpaceId

{: .table .table-bordered}
|Syntax     | @SpaceId(autoGenerate=false)|
|Argument   |  boolean          |
|Default    | false |
|Description| Defines whether this field value is used when generating the Object ID. The field value should be unique -- i.e., no multiple objects with the same value should be written into the space (each object should have a different field value). When writing an object into the space with an existing `id` field value, an `EntryAlreadyInSpaceException` is thrown. The Object ID is created, based on the `id` field value.{%wbr%}Specifies if the object ID is generated automatically by the space when written into the space. If `false`, the field is indexed automatically, and if `true`, the field isn't indexed. If `autoGenerate` is declared as `false`, the field is indexed automatically. If `autoGenerate` is declared as `true`, the field isn't indexed. If `autoGenerate` is `true`, the field must be of the type `java.lang.String`. |





{% togglecloak id=1 %}**Example**{% endtogglecloak %}
{% gcloak 1 %}
{%highlight java%}
@SpaceClass
public class Person {

  private Long id;

  @SpaceId(autoGenerate=false)
  public Long getId()
  {
    return id;
  }
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./space-object-id-operations.html{%endlearn%}


# SpaceRouting

{: .table .table-bordered}
|Syntax     | @SpaceRouting|
|Description| The `@SpaceRouting` annotation specifies a get method for the field to be used to calculate the target space for the space operation (read , write...). The `@SpaceRouting` field value hash code is used to calculate the target space when the space is running in **partitioned mode**.{%wbr%}The field value hash code is used to calculate the target space when the space is running in **partitioned mode**. |


{% togglecloak id=2 %}**Example**{% endtogglecloak %}{% gcloak 2 %}
{%highlight java%}
@SpaceClass
public class Employee {

  private Long departmentId;

  @SpaceRouting
  public Long getDepartmentId()
  {
    return departmentId;
  }
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./data-partitioning.html{%endlearn%}


# SpaceProperty

{: .table .table-bordered}
|Syntax     | @SpaceProperty(nullValue="-1" )|
|Argument   |  nullValue          |
|Default    |  null |
|Description| Specifies that an attribute value be treated as `null` when the object is written to the space and no value is assigned to the attribute. (where `-1` functions as a `null` value in case of an int)|



{% togglecloak id=3 %}**Example**{% endtogglecloak %}
{% gcloak 3 %}
{%highlight java%}
@SpaceClass
public class Employee {

  private int age;

  @SpaceProperty(nullValue="-1" )
  public int getAge()
  {
    return age;
  }
}
{%endhighlight%}
{% endgcloak %}

# SpaceIndex

{: .table .table-bordered}
|Syntax     |  @SpaceIndex(type=SpaceIndexType.BASIC)|
|Argument   |  [SpaceIndexType]({%javadoc com/gigaspaces/metadata/index/SpaceIndexType %})  |
|Description| Querying indexed fields speeds up read and take operations. The `@SpaceIndex` annotation should be used to specify an indexed field.|


{% togglecloak id=4 %}**Example**{% endtogglecloak %}
{% gcloak 4 %}
{%highlight java%}
@SpaceClass
public class User {

	private Long id;
	private String name;
	private Double balance;
	private Double creditLimit;
	private EAccountStatus status;
	private Address address;
	private Map<String, String> contacts;

	public User() {
	}

	@SpaceId(autoGenerate = false)
	@SpaceRouting
	public Long getId() {
		return id;
	}

	@SpaceIndex(type = SpaceIndexType.BASIC)
	public String getName() {
		return name;
	}

	@SpaceIndex(type = SpaceIndexType.EXTENDED)
	public Double getCreditLimit() {
		return creditLimit;
	}
}
{%endhighlight%}
{% endgcloak %}

{%learn%}./indexing.html{%endlearn%}

# Unique Index

{: .table .table-bordered}
|Syntax     |   @SpaceIndex(type=SpaceIndexType.BASIC, unique = true)|
|Argument   |  [SpaceIndexType]({%javadoc com/gigaspaces/metadata/index/SpaceIndexType %})  |
|Description| Unique constraints can be defined for an attribute or attributes of a space class. |
|Note |   The uniqueness is enforced per partition and not over the whole cluster. |

{% togglecloak id=44 %}**Example**{% endtogglecloak %}
{% gcloak 44 %}
{%highlight java%}
@SpaceClass
public class Person
{
  @SpaceIndex(type=SpaceIndexType.BASIC, unique = true)
  private String lastName;

  @SpaceIndex(type=SpaceIndexType.BASIC)
  private String firstName;

  @SpaceIndex(type=SpaceIndexType.EXTENDED)
  private Integer age;
 .
 .
}
{%endhighlight%}
{% endgcloak %}

{%learn%}./indexing.html{%endlearn%}

# SpaceIndex Path

{: .table .table-bordered}
|Syntax     |  @SpaceIndex(path = "attributeName",type = SpaceIndexType.EXTENDED)|
|Argument   |  [SpaceIndexType]({%javadoc com/gigaspaces/metadata/index/SpaceIndexType %}){%wbr%} path - indexed attribute|
|Description| The `path()` attribute represents the path of the indexed property within a nested object. |


{% togglecloak id=5 %}**Example**{% endtogglecloak %}
{% gcloak 5 %}
{%highlight java%}
@SpaceClass
public class Person {
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
	private Address address;
	private Date birthday;
	private long socialSecurity;
	private int _id;
	//getter and setter methods
}

public static class Address implements Serializable {
	private int zipCode;
	private String street;
	//getter and setter methods
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./indexing-nested-properties.html{%endlearn%}

# SpaceVersion

{: .table .table-bordered}
|Syntax     |  @SpaceVersion|
|Description| This annotation is used for object versioning used for optimistic locking. |
|Note       | The attribute must be an `int` data type. |


{% togglecloak id=6 %}**Example**{% endtogglecloak %}
{% gcloak 6 %}
{%highlight java%}
@SpaceClass
public class Employee {

  private int version;

  @SpaceVersion
  public int getVersion()
  {
    return version;
  }
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./optimistic-locking.html{%endlearn%}

# SpacePersist

{: .table .table-bordered}
|Syntax     | @SpacePersist|
|Description| This specifies a getter method for holding the persistency mode of the object overriding the class level persist declaration. This field should be of the boolean data type.{%wbr%}If the persist class level annotation is true, all objects of this class type will be persisted into the underlying data store (Mirror, ExternalDataSource, Storage Adapter).|
|Note       | When using this option, you must have the space class level `persist` decoration specified.|

{% togglecloak id=7 %}**Example**{% endtogglecloak %}
{% gcloak 7 %}
{%highlight java%}
@SpaceClass(persist=true)
public class Employee {

  private boolean persist;

  @SpacePersist
  public boolean isPersist()
  {
    return persist;
  }
}
{%endhighlight%}
{% endgcloak %}


# SpaceExclude

{: .table .table-bordered}
|Syntax     |  @SpaceExclude|
|Description| When this annotation is specified the attribute is not written into the space.|
|Note | - When `IncludeProperties` is defined as `IMPLICIT`, `@SpaceExclude` should usually be used. This is because `IMPLICIT` instructs the system to take all POJO fields into account.{%wbr%}- When `IncludeProperties` is defined as `EXPLICIT`, there is no need to use `@SpaceExclude`.{%wbr%}- `@SpaceExclude` can still be used, even if `IncludeProperties` is not defined.  |


{% togglecloak id=8 %}**Example**{% endtogglecloak %}
{% gcloak 8 %}
{%highlight java%}
@SpaceClass
public class Employee {

  private String mothersName;

  @SpaceExclude
  public String getMothersName()
  {
    return mothersName;
  }
}
{%endhighlight%}
{% endgcloak %}

# SpaceLeaseExpiration

{: .table .table-bordered}
|Syntax     |  @SpaceLeaseExpiration|
|Description|This annotation specifies the attribute for holding the timestamp of when the instance's lease expires (this is a standard Java timestamp based on the 1/1/1970 epoch). This property should not be populated by the user code. The space will populate this property automatically based on the lease time given by the user when writing the object. When using an external data source, you can choose to persist this value to the database. Subsequently, when data is reloaded from the external data source (at startup time for example), the space will filter out instances whose lease expiration timestamp has already passed. This field should be a `long` data type.|


{% togglecloak id=81 %}**Example**{% endtogglecloak %}
{% gcloak 81 %}
{%highlight java%}
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
{%endhighlight%}
{% endgcloak %}
{%learn%}./leases---automatic-expiration.html{%endlearn%}

# SpaceStorageType

{: .table .table-bordered}
|Syntax     | @SpaceStorageType(storageType=StorageType.BINARY)|
|Argument   | [StorageType]({% javadoc com/gigaspaces/metadata/StorageType %})          |
|Default    | StorageType.OBJECT |
|Description| This annotation is used to specify how the attribute is stored in the space. |


{% togglecloak id=10 %}**Example**{% endtogglecloak %}
{% gcloak 10 %}
{%highlight java%}
@SpaceClass
public class Message {

  private String payLoad;

  @SpaceStorageType(storageType=StorageType.BINARY)
  public String getpayLoad()
  {
    return payLoad;
  }
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./storage-types---controlling-serialization.html{%endlearn%}


# SpaceFifoGroupingProperty

{: .table .table-bordered}
|Syntax     | @SpaceFifoGroupingProperty(path = "attributeName")|
|Argument   | path          |
|Description| This annotation is used to define a space FIFO grouping property. |
|Note | If defined, the `TakeModifiers.FIFO_GROUPING_POLL` or `ReadModifiers.FIFO_GROUPING_POLL` modifiers can be used to return all space entries that match the selection template in FIFO order. Different values of the FG property define groups of space entries that match each value. FIFO ordering exists within each group and not between different groups. |

{% togglecloak id=11 %}**Example**{% endtogglecloak %}
{% gcloak 11 %}
{%highlight java%}
@SpaceClass
public class FlightReservation
{
    private FlightInfo flightInfo;
    private Person customer;
	private State processingState;
    ...
	@SpaceFifoGroupingProperty(path = "flightNumber")
    public FlightInfo getFlightInfo() {return flightInfo;}
   	public void setFlightInfo(FlightInfo flightInfo) {this.flightInfo = flightInfo;}
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./fifo-grouping.html{%endlearn%}


# SpaceFifoGroupingIndex

{: .table .table-bordered}
|Syntax     | @SpaceFifoGroupingIndex|
|Description| This annotation is used to define a space FIFO grouping Index. |
|Note |This annotation can be declared on several properties in a class in order to assist in efficient traversal.{%wbr%}If defined, there must be a property in the class, marked with the `@SpaceFifoGroupingProperty` annotation.{%wbr%}A compound index that contains this FIFO grouping index and the FIFO grouping property will be created.   |


{% togglecloak id=12 %}**Example**{% endtogglecloak %}
{% gcloak 12 %}
{%highlight java%}

    @SpaceFifoGroupingIndex
    public State getProcessingState() {return processingState;}
    public void setProcessed (State processingState) {this.processingState = processingState;}

    @SpaceFifoGroupingIndex(path = "id")
    public Person getCustomer() {return customer;}
    public void setCustomer (Person customer) {this.customer = customer;}

{%endhighlight%}
{% endgcloak %}
{%learn%}./fifo-grouping.html{%endlearn%}

# SpaceClassConstructor

{: .table .table-bordered}
|Syntax     | @SpaceClassConstructor|
|Description| This annotation can be placed on a POJO constructor to denote that this constructor should be used during object instantiation.{%wbr%}Using this annotations, it is possible for the POJO to have immutable properties (i.e. `final` fields).{%wbr%}As opposed to a standard POJO, a POJO annotated with this annotation may omit setters for its properties.{%wbr%}Except for the case where the id property is auto generated, only properties defined in this constructor will be considered space properties.{%wbr%}The annotations can be placed on at most one constructor.|


{%learn%}./fifo-grouping.html{%endlearn%}

# SpaceDynamicProperties

{: .table .table-bordered}
|Syntax     | @SpaceDynamicProperties|
|Description| Allows adding properties freely to a class without worrying about the schema.|



{% togglecloak id=13 %}**Example**{% endtogglecloak %}
{% gcloak 13 %}
{%highlight java%}
@SpaceClass
public class Person {
    public Person (){}
    private String name;
    private Integer id;
    private DocumentProperties extraInfo;

    public String getName() {return name}
    public void setName(String name) {this.name=name}

    @SpaceId
    public Integer getId() {return id;}
    public void setId(Integer id) {this.id=id;}

    @SpaceDynamicProperties
    public DocumentProperties getExtraInfo() {return extraInfo;}
    public void setExtraInfo(DocumentProperties extraInfo) {this.extraInfo=extraInfo;}
}
{%endhighlight%}
{% endgcloak %}
 {%learn%}./dynamic-properties.html{%endlearn%}



{%comment%}
==========================================================================
Defines whether this field value is used when generating the Object ID. The field value should be unique -- i.e., no multiple objects with the same value should be written into the space (each object should have a different field value). When writing an object into the space with an existing `id` field value, an `EntryAlreadyInSpaceException` is thrown. The Object ID is created, based on the `id` field value.

{: .table .table-bordered}
| Element | Type | Description | Default Value |
|:--------|:-----|:------------|:--------------|
| `autoGenerate` | boolean | Specifies if the object ID is generated automatically by the space when written into the space. If `false`, the field is indexed automatically, and if `true`, the field isn't indexed | `false` |

If `autoGenerate` is declared as `false`, the field is indexed automatically. If `autoGenerate` is declared as `true`, the field isn't indexed. If `autoGenerate` is `true`, the field must be of the type `java.lang.String`.

{% warning %}
 The `@SpaceID` annotation cannot be used with multiple fields. You may specify only **one** field to be used as the `@SpaceId` field.
{% endwarning %}

{%learn%}./space-object-id-operations.html{% endlearn %}



# @SpaceProperty

{: .table .table-bordered}
| Element | Type | Description | Default Value |
|:--------|:-----|:------------|:--------------|
| `nullValue` | String | Specifies that a value be treated as `null`. | |

Example:

{% highlight java %}
@SpaceProperty(nullValue="-1" )
public int getEmployeeID()
{
	return employeeID;
}
{% endhighlight %}

where `-1` functions as a `null` value.



# @SpaceIndex

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

{% learn %}./indexing.html{%endlearn%}

{% note %}
It is highly recommended to index fields used for matching/query. Without the proper index (BASIC or EXTENDED ), the read/readMultiple/take/takeMultiple operations response time might be affected.
{% endnote %}


# @SpaceVersion

This specifies a get method for holding the version ID. This field should be an `int` data type.

{% note %} The `@SpaceVersion` must be an `int` data type.{%endnote%}

# @SpacePersist

This specifies a getter method for holding the persistency mode of the object overriding the class level `persist` declaration. This field should be of the `boolean` data type.
If the `persist` class level annotation is `true`, all objects of this class type will be persisted into the underlying data store (Mirror, ExternalDataSource, Storage Adapter).

{% tip %}
When using this option, you must have the space class level `persist` decoration specified.
{% endtip %}

# @SpaceRouting

The `@SpaceRouting` annotation specifies a get method for the field to be used to calculate the target space for the space operation (read , write...). The `@SpaceRouting` field value hash code is used to calculate the target space when the space is running in **partitioned mode**.
See more details at the [Data-Partitioning](./data-partitioning.html) section.

{% tip %}
For details about scaling a running space cluster **in runtime** see the [Elastic Processing Unit](./elastic-processing-unit.html) section.
{% endtip %}

{% anchor SpaceLeaseExpiration %}


# @SpaceLeaseExpiration

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

# @SpaceExclude

The `@SpaceExclude` annotation instructs the client to ignore the fields using this annotation, so that they are not stored within the space.

- When `IncludeProperties` is defined as `IMPLICIT` as part of the [@SpaceClass annotation](#1), `@SpaceExclude` should usually be used. This is because `IMPLICIT` instructs the system to take all POJO fields into account.
- When `IncludeProperties` is defined as `EXPLICIT`, there is no need to use `@SpaceExclude`.
- `@SpaceExclude` can still be used, even if `IncludeProperties` is not defined.

# @SpaceStorageType

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

# @SpaceFifoGroupingProperty

The `@SpaceFifoGroupingProperty` annotation should be used to define a space FIFO grouping property.
If defined, the `TakeModifiers.FIFO_GROUPING_POLL` or `ReadModifiers.FIFO_GROUPING_POLL` modifiers can be used to return
all space entries that match the selection template in FIFO order.
Different values of the FG property define groups of space entries that match each value -
FIFO ordering exists within each group and not between different groups.

{% refer %}For more details and examples, refer to the [FIFO Grouping](./fifo-grouping.html) section.{% endrefer %}

# @SpaceFifoGroupingIndex

The `@SpaceFifoGroupingIndex` annotation should be used to define a space FIFO grouping Index.
Can be declared on several properties in a class in order to assist in efficient traversal.
If defined, there must be a property in the class, marked with the `@SpaceFifoGroupingProperty` annotation.
A compound index that contains this FIFO grouping index and the FIFO grouping property will be created.

{% refer %}For more details and examples, refer to the [FIFO Grouping](./fifo-grouping.html) section.{% endrefer %}

{% anchor SpaceClassConstructor %}

# @SpaceClassConstructor

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

{%endcomment%}
