

# Code Snippets

{% lampon %} Space operations with POJO objects can be conducted using the [org.openspaces.core.GigaSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html) interface or the [com.j_spaces.core.IJSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/j_spaces/core/IJSpace.html) interface.

{% lampon %} **The code snippets below use the** [org.openspaces.core.GigaSpace](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html) interface that is the recommended interface.

{% inittab code_examples %}
{% tabcontent Write and Read %}

## Write and Read

In order to write or update objects in the Space, you should use the `write` method of the `GigaSpace` interface. The `write` method is used to write objects if these are introduced for the first time, or update them if these already exist in the space. In order to override these default semantics, you can use the overloaded `write` methods which accept update modifiers such as `UpdateModifiers.UPDATE_ONLY`.

The `read` methods are used to retrieve objects from the Space. The `read` method returns a copy of the matching object to the client. To read more than one object, you should use the `readMultiple` methods of the `GigaSpace` interface. To define the criteria for the operation, all of these methods accept either a template object, or an `SQLQuery` instance. A template object is an example object of the class you would like to read. For an object in the space to match the template, each of the non-null properties in the template must match its values for these properties. To read an object by its ID (key), you should use one of the `readById`/`readByIds` methods.

{% indent %}
![POJO_write.jpg](/attachment_files/POJO_write.jpg)
{% endindent %}

{% indent %}
![POJO_read.jpg](/attachment_files/POJO_read.jpg)
{% endindent %}

Getting Space proxy:

{% highlight java %}
UrlSpaceConfigurer urlSpaceConfigurer = new UrlSpaceConfigurer("jini://*/*/mySpace");
GigaSpace space = new GigaSpaceConfigurer(urlSpaceConfigurer.space())
	.defaultTakeTimeout(1000)
 	.defaultReadTimeout(1000)
 	.gigaSpace();
{% endhighlight %}

The following writes an `Employee` object and reads it back using a simple template:

{% highlight java %}
GigaSpace space;
Employee employee = new Employee("Last Name", new Integer(32));
employee.setFirstName("first name");
LeaseContext<Employee> lc = space.write(employee);
Employee template = new Employee();
Employee result = space.read(template);
{% endhighlight %}

{% endtabcontent %}
{% tabcontent Notification Registration %}

## Notification Registration

The following registers for notifications:

{% highlight java %}
GigaSpace space;

 SimpleNotifyEventListenerContainer
	notifyEventListenerContainer = new SimpleNotifyContainerConfigurer(space)
	.template(new Employee())
	.eventListenerAnnotation(new Object()
		{
		@SpaceDataEvent
		public void eventHappened(Object event) {
		System.out.println("onEvent called Got" + event);
	   	}
	})
	.fifo(true)
	.notifyWrite(true)
	.notifyUpdate(true)
	.notifyContainer();
{% endhighlight %}

{% endtabcontent %}

{% tabcontent Batch Write %}

## Batch Write

When writing a batch of objects into the space, these should be placed into an array to be used by the `GigaSpace.writeMultiple` operation. The returned array will include the corresponding `LeaseContext` object.

{% indent %}
![POJO_write_multi.jpg](/attachment_files/POJO_write_multi.jpg)
{% endindent %}

{% highlight java %}
GigaSpace space;
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

{% endtabcontent %}
{% tabcontent Batch Read %}

## Batch Read

{% indent %}
![POJO_read_multi.jpg](/attachment_files/POJO_read_multi.jpg)
{% endindent %}

The following queries the space using SQL:

{% highlight java %}
GigaSpace space;
String querystr	= "age>40";
SQLQuery query = new SQLQuery(Employee.class, querystr);
Employee results[] = space.readMultiple(query , Integer.MAX_VALUE);
{% endhighlight %}

{% note %}
Constructing `SQLQuery` objects is a relatively expensive operation. You **should not construct these with every space query** operation. Instead, it is recommended to construct it once, and then use it with dynamic query options: `SQLQuery.setParameters` and `SQLQuery.setParameter`.
{% endnote %}
{% endtabcontent %}

{% tabcontent Clear %}

## Clear Objects

{% indent %}
![POJO_clear.jpg](/attachment_files/POJO_clear.jpg)
{% endindent %}

You can use the SQLQuery with the `GigaSpace.clear` to remove objects from the space:

{% highlight java %}
GigaSpace space;
String querystr	= "age>30";
SQLQuery query = new SQLQuery(Employee.class, querystr);
space.clear(query);
{% endhighlight %}

{% note %}
When using the SQLQuery with bigger/less than queries, turn on the [extended indexing](./indexing.html#ExtendedIndexing).
{% endnote %}
{% endtabcontent %}

{% tabcontent Updating an Object %}

## Updating an Object

{% indent %}
![POJO_update.jpg](/attachment_files/POJO_update.jpg)
{% endindent %}

The `GigaSpace.write` with the [WriteModifiers.UPDATE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier should be used to explicitly perform an update operation. The [WriteModifiers.UPDATE_OR_WRITE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html) is the default mode with `write` operations. This means that subsequent calls to the `write` operation with an object with identical `SpaceId` will result in an update operation - i.e. a new object will not be inserted into the space.

{% exclamation %} Make sure your Space Class will have the `SpaceId(autoGenerate=false)` when performing **update** operations.

The `GigaSpace.write` has a few activity modes - **With each mode the return object options are different.**:

1. Inserting or updating an existing object - The [WriteModifiers.UPDATE_OR_WRITE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier should be used. This is the default mode.
1. Inserting a new object into the space - The [WriteModifiers.WRITE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier should be used.
1. Updating an existing object - The [WriteModifiers.UPDATE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier should be used.
1. Updating an existing object but sending only the modified fields to the space - The [WriteModifiers.PARTIAL_UPDATE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier should be used.

- when the [WriteModifiers.UPDATE_OR_WRITE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier is applied, the following returns:
    - For a successful operation:
        - `LeaseContext` - The `LeaseContext.getObject()` will return:
            - `null` - if a new object is inserted (write operation)
            - The previous version of the object (update operation)
    - For an unsuccessful operation:
        - an
[UpdateOperationTimeoutException](http://www.gigaspaces.com/docs/JavaDoc{%currentversion%}/org/openspaces/core/UpdateOperationTimeoutException.html)
is thrown if a timeout occurred. This means the object is locked under another transaction.

- when the [WriteModifiers.WRITE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier is applied the following returns:
    - For a successful operation:
        - `LeaseContext` - Where the `LeaseContext.getObject()` will return a `null`.
    - For an unsuccessful operation:
        - an
[EntryAlreadyInSpaceException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/EntryAlreadyInSpaceException.html)
is thrown.

- when the [WriteModifiers.UPDATE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier is applied the following returns:
    - For a successful operation:
        - `LeaseContext` - Where the `LeaseContext.getObject()` will return the previous version of the object.
    - For an unsuccessful operation
        - `null` - if a timeout occurred. This means the object is locked under another transaction.
        - an Exception object is thrown - the options are:
            - [EntryNotInSpaceException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/EntryNotInSpaceException.html)
\- in case the object does not exist in the space.
            - [SpaceOptimisticLockingFailureException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/SpaceOptimisticLockingFailureException.html)
. Thrown only when running in Optimistic Locking mode. This Exception includes the existing version id of the object within the space and the client side version id of the object. In this case you should read the object again and retry the update operation. See [Optimistic Locking](./optimistic-locking.html) for more details.

- when the [WriteModifiers.PARTIAL_UPDATE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html) modifier is applied the return values are the same as with the `WriteModifiers.UPDATE_ONLY` case. Fields that should not be updated **should have the value `null`**. This means that only fields which are set will be sent into the space to replace the existing field's value. Make sure the updated object include its ID when using this option.

When updating an object, you can specify 0 (ZERO) as the lease time. This will instruct the space to use the original lease time used when the object has been written into the space.

UPDATE_OR_WRITE Example:

{% highlight java %}
try
{
	LeaseContext ret = space.write(employee ,/*lease*/  0 ,/*timeout*/  1000 , WriteModifiers.UPDATE_OR_WRITE);
	if ( ret.getObject() == null)
	{
		//  successful write
	}
	if (ret.getObject() instanceof Employee)
	{
		//  successful update
	}
}
catch (UpdateOperationTimeoutException uote)
{
	// Object is locked - unsuccessful update
}
{% endhighlight %}

WRITE_ONLY Example:

{% highlight java %}
try
{
	LeaseContext ret = space.write(employee ,/*lease*/  0 ,/*timeout*/  1000 , WriteModifiers.WRITE_ONLY);
	if ( ret.getObject() == null)
	{
		//  successful write
	}
}
catch (EntryAlreadyInSpaceException eainse)
{
	// Object already exists - unsuccessful write
}
{% endhighlight %}

UPDATE_ONLY Example:

{% highlight java %}
try
{
	LeaseContext ret = space.write(employee ,/*lease*/  0 ,/*timeout*/  1000 , WriteModifiers.UPDATE_ONLY);
	if ( ret == null)
	{
		// Object is locked - unsuccessful update
	}
	else if (ret.getObject() instanceof Employee)
	{
		//  successful update
	}
}
catch (EntryNotInSpaceException enise)
{
	// Object not in space - unsuccessful update
}
catch (SpaceOptimisticLockingFailureException solfe)
{
	// Client holds wrong version of the object - unsuccessful update. We need to read it again and issue the update call again.
}
{% endhighlight %}

PARTIAL_UPDATE Example:

{% highlight java %}
GigaSpace space = new GigaSpaceConfigurer (new UrlSpaceConfigurer("jini://*/*/mySpace").noWriteLease(true)).gigaSpace();

// initial insert
MyClass obj = new MyClass();
obj.setId("1");
obj.setField1("A");
obj.setField2("B");
obj.setField3("C");
space.write(obj);

// reading object back from the space
MyClass obj2 = space.readById(MyClass.class , "1");

// updating only field2
obj2.setField1(null);
obj2.setField2("BBBB");
obj2.setField3(null);
try
{
	space.write(obj2,0,0,WriteModifiers.PARTIAL_UPDATE);
}
catch (EntryNotInSpaceException enise)
{
	// Object not in space - unsuccessful update
}
{% endhighlight %}

{% endtabcontent %}

{% tabcontent Batch Update %}

## Batch Update

{% indent %}
![POJO_update_multi.jpg](/attachment_files/POJO_update_multi.jpg)
{% endindent %}

{% exclamation %} Make sure your Space Class will have the `SpaceId(autoGenerate=false)` when performing update operations.

The `GigaSpace.writeMultiple` returns an array of objects which correspond to the input object array. The returned object element can be one of the following:

- when the [WriteModifiers.UPDATE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html) modifier is applied the following returns:
    - For a successful operation:
        - **The previous version of the object**
    - For an unsuccessful operation:
        - null - if a timeout occurred. This means the object is locked under another transaction.
        - an Exception object - the options are:
            - [EntryNotInSpaceException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/EntryNotInSpaceException.html)
\- in case the entry does not exist
            - [SpaceOptimisticLockingFailureException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/SpaceOptimisticLockingFailureException.html)

- when the [WriteModifiers.UPDATE_OR_WRITE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html) modifier is applied the following returns:
    - For a successful operation:
        - null - if a new object is inserted (write operation)
        - The previous version of the object (update operation)

{% tip %}
Since the `GigaSpace.writeMultiple` in
[WriteModifiers.UPDATE_OR_WRITE](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/WriteModifiers.html)
mode does not support timeout based updates, there is no way to identify if an updated object is already locked under a transaction - i.e. the
[UpdateOperationTimeoutException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/UpdateOperationTimeoutException.html) **is not returned** as part of the returned array elements.
With a transactional system, it is recommended to perform batch updates using the [WriteModifiers.UPDATE_ONLY](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html)
modifier.
{% endtip %}

UPDATE_ONLY Example:

{% highlight java %}
GigaSpace space;
Employee employees[] = space.readMultiple(query , 10000);
	Object retUpdateMulti[] = space.writeMultiple(employees ,/*leases*/ new long[results.length],WriteModifiers.UPDATE_ONLY);

for (int i = 0;i<retUpdateMulti ; i++)
{
	if  (retUpdateMulti[i] == null ) {
		//  unsuccessful update
		break;
	}
	else if  (retUpdateMulti[i] instanceof Exception) {
		//  unsuccessful update
		if (retUpdateMulti[i] instanceof EntryNotInSpaceException)
		{
		...
		}

		else if (retUpdateMulti[i] instanceof SpaceOptimisticLockingFailureException)
		{
		...
		}

		break;
	}

	else if  (retUpdateMulti[i] instanceof Employee ) {
		//  successful update
	}
}
{% endhighlight %}

PARTIAL_UPDATE Example:

{% highlight java %}
GigaSpace space;
for (int i=0;i<employees.length;i++)
{
	employees[i].setFirstName(null);
	employees[i].setLastName(null);
	employees[i].setBalance(newValue);
	leases[i] = Lease.FOREVER;
}

space.writeMultiple(employees, Lease.FOREVER, WriteModifiers.PARTIAL_UPDATE);
{% endhighlight %}

{% endtabcontent %}

{% tabcontent Changing an Object %}

## Changing an Object

{% include xap97/change-api-code-snippet.markdown %}
{% endtabcontent %}
{% endinittab %}

