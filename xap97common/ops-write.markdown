
# The Write Operation
{%section%}
{%column width=60% %}
In order to write objects to the Space, you use the write method of the GigaSpace interface. The write method is used to write objects if these are introduced for the first time, or update them if these already exist in the space. In order to override these default semantics, you can use the overloaded write methods which accept update modifiers such as UpdateModifiers.UPDATE_ONLY.
{%endcolumn%}
{%column width=35% %}
![POJO_write.jpg](/attachment_files/POJO_write.jpg)
{%endcolumn%}
{%endsection%}


#### POJO Example

The following example writes an `Employee` object into the space:

{% highlight java %}
    UrlSpaceConfigurer urlSpaceConfigurer = new UrlSpaceConfigurer("jini://*/*/mySpace");
    GigaSpace space = new GigaSpaceConfigurer(urlSpaceConfigurer.space())
 	.gigaSpace();

    Employee employee = new Employee("Last Name", new Integer(32));
    employee.setFirstName("first name");
    LeaseContext<Employee> lc = space.write(employee);
{% endhighlight %}

#### SpaceDocument Example

Here is an example how you create a SpaceDocument, register it with the space and then write it into the space:

{%highlight java  %}

     // Create the document
     DocumentProperties properties = new DocumentProperties()
       .setProperty("CatalogNumber", "av-9876")
       .setProperty("Category", "Aviation")
       .setProperty("Name", "Jet Propelled Pogo Stick")
       .setProperty("Price", 19.99f)
       .setProperty("Tags",
            new String[] { "New", "Cool", "Pogo", "Jet" })
       .setProperty("Features",
            new DocumentProperties()
              .setProperty("Manufacturer", "Acme")
              .setProperty("RequiresAssembly", true)
              .setProperty("NumberOfParts", 42));

     SpaceDocument doc = new SpaceDocument("Product", properties);

     // Register the document
     // Create type descriptor:
     SpaceTypeDescriptor typeDescriptor = new SpaceTypeDescriptorBuilder(
		"Product").idProperty("CatalogNumber")
		.routingProperty("Category")
		.addPropertyIndex("Name", SpaceIndexType.BASIC)
		.addPropertyIndex("Price", SpaceIndexType.EXTENDED).create();
     // Register type:
     space.getTypeManager().registerTypeDescriptor(typeDescriptor);

    // Write the document into the space
    LeaseContext<SpaceDocument> lc = space.write(document);
{%endhighlight%}

{%comment%}
#### Delta Update

You may update selected space object fields (delta) using the [WriteModifiers.PARTIAL_UPDATE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html) modifier. This option is useful when having objects with large number of fields where you would like to update only few of the space object fields. This optimizes the network utilization and avoids serializing/de-serializing the entire object fields when interacting with a remote space.

#### How to Perform Delta Updates?

When using this modifier, fields that you do not want be update **should have the value `null`**. This means that only fields which are set will be sent from the client into the space to replace the existing field's value. In case of a backup (replica) space, the primary space will replicate only the updated fields (delta) to the replica space. Make sure the updated object include its ID when using this option.

{% note %}
To use Delta updates you don't have to implement any special interface or have special serialization code. You can use regular POJO as usual.
{%endnote%}

When updating an object, you can specify 0 (ZERO) as the lease time. This will instruct the space to use the original lease time used when the object has been written into the space.

`PARTIAL_UPDATE` Example:

{% highlight java %}
	  // initial insert
	  Employee emp = new Employee( );
	  emp.setId(new Integer(1));
	  emp.setFirstName("FirstName");
	  emp.setLastName("LastName");
	  emp.setAge(new Integer(22));

	  space.write(emp);

	  // reading object back from the space
	  Employee emp2 = space.readById(Employee.class , new Integer(1));

	  // updating only lastName
	  emp2.setFirstName(null);
	  emp2.setLastName("LastName2");
	  emp2.setAge(null);

	  space.write(emp2, WriteModifiers.PARTIAL_UPDATE);
{% endhighlight %}

Alternatively, you can use the [change](./change-api.html) operation and update specific fields or even nested fields or modify collections and maps without having to supply the entire collection or map upon such update.
{%endcomment%}

#### Time To Live

To write an object into the space with a limited time to live you should specify [a lease value](./leases---automatic-expiration.html) (in millisecond). The object will expire automatically from the space.

{% highlight java %}
   gigaSpace.write(myObject, 10000)
{% endhighlight %}

{%anchor writeMultiple%}

#### Write Multiple
{%section%}
{%column width=60% %}
When writing a batch of objects into the space, these should be placed into an array to be used by the `GigaSpace.writeMultiple` operation. The returned array will include the corresponding `LeaseContext` object.
{%endcolumn%}
{%column width=35% %}
![POJO_write_multi.jpg](/attachment_files/POJO_write_multi.jpg)
{%endcolumn%}
{%endsection%}


#### Example

{% highlight java %}

   Employee emps[] = new Employee[2];
   emps[0] = new Employee("Last Name A", new Integer(10));
   emps[1] = new Employee("Last Name B", new Integer(20));
   try {
    LeaseContext[] leaseContexts = space.writeMultiple(emps);
    for (int i = 0;i<leaseContexts.length ; i++) {
        System.out.println ("Object UID " + leaseContexts[i].getUID() + " inserted into the space");
    }
   } catch (WriteMultipleException e) {
    IWriteResult[] writeResult = e.getResults();
    for (int i = 0;i< writeResult.length ; i++) {
        System.out.println ("Problem with Object UID " + writeResult ");
    }
  }
{% endhighlight %}

{%note title=Here are few important considerations when using the batch operation:%}
-  should be performed with transactions - this allows the client to roll back the space to its initial state prior the operation was started, in case of a failure.
-  make sure `null` values are not part of the passed array.
-  you should verify that duplicated entries (with the same ID) do not appear as part of the passed array, since the identity of the object is determined based on its `ID` and not based on its reference. This is extremely important with an embedded space, since `writeMultiple` injects the ID value into the object after the write operation (when autogenerate=false).

- Exception handling - the operation many throw the following Exceptions.
    - [WriteMultiplePartialFailureException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/WriteMultiplePartialFailureException.html)
    - [WriteMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/WriteMultipleException.html)

{%endnote%}


#### Return Previous Value
{%section%}
{%column width=60% %}
When updating an object which already exists in the space, in some scenarios it is useful to get the previous value of the object (before the update). This previous value is returned in result `LeaseContext.getObject()` when using the `RETURN_PREV_ON_UPDATE` modifier.
{%endcolumn%}
{%column width=35% %}
![write_return_prev-value.jpg](/attachment_files/write_return_prev-value.jpg)
{%endcolumn%}
{%endsection%}

{% highlight java %}
  LeaseContext<MyData> lc = space.write(myobject,WriteModifiers.RETURN_PREV_ON_UPDATE.add(WriteModifiers.UPDATE_OR_WRITE));
  MyData previousValue = lc.getObject();
{% endhighlight %}

{% info %}
Since in most scenarios the previous value is irrelevant, the default behavior is not to return it (i.e. `LeaseContext.getObject()` return null). The `RETURN_PREV_ON_UPDATE` modifier is used to indicate the previous value should be returned.
{%endinfo%}

#### Asynchronous write
{%section%}
{%column width=60% %}
Asynchronous `write` operation can be implemented using a [Task](./task-execution-over-the-space.html), where the `Task` implementation include a write operation. With this approach the `Task` is sent to the space and executed in an asynchronous manner. The write operation itself will be completed once both the primary and the backup will acknowledge the operation. This activity will be performed as a background activity from the client perspective.
{%endcolumn%}
{%column width=35% %}
![write-oneway.png](/attachment_files/POJO_write_oneway.png)
{%endcolumn%}
{%endsection%}

#### Example

{% highlight java %}
  GigaSpace space = new GigaSpaceConfigurer (new UrlSpaceConfigurer("jini://*/*/space")).gigaSpace();
  MyClass obj = new MyClass(1,"AAA");
  space.write(obj,WriteModifiers.ONE_WAY);
{% endhighlight %}


#### Modifiers

For further details on each of the available modifiers see: [WriteModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html)

{%note%}
Writing an object into a space might generate [notifications](./notify-container.html) to registered objects.
{%endnote%}

{% togglecloak id=os-write %}**Method summary...**{% endtogglecloak %}
{% gcloak os-write %}

Writes a new object to the space, returning its LeaseContext.{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#write(T){%endjavaapi%}

{%highlight java%}
<T> LeaseContext<T> write(T entry) throws DataAccessException
<T> LeaseContext<T> write(T entry, long lease, long timeout, WriteModifiers modifiers) throws DataAccessException
......

{%endhighlight%}

Writes new objects to the space, returning its LeaseContexts.{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#writeMultiple(T[]){%endjavaapi%}
{%highlight java%}
<T> LeaseContext<T>[] writeMultiple(T[] entries) throws DataAccessException
<T> LeaseContext<T>[] writeMultiple(T[] entries, long[] leases, WriteModifiers modifiers) throws DataAccessException
......
{%endhighlight%}

{: .table .table-bordered}
| Modifier and Type | Description | default |
|:-----|:------------|:-------- |
|T          | POJO, SpaceDocument||
|lease       |Time to live | Lease.FOREVER|milliseconds|
|timeout     | The timeout of an update operation, in milliseconds. If the entry is locked by another transaction wait for the specified number of milliseconds for it to be released. | 0  |
|[WriteModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html)|Provides modifiers to customize the behavior of write operations | UPDATE_OR_WRITE  |
|[LeaseContext](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/j_spaces/core/LeaseContext.html) |LeaseContext is a return-value encapsulation of a write operation.| |
{% endgcloak  %}


