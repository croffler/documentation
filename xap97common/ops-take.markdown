
{%anchor take-operation%}

# The Take Operation
{%section%}
{%column width=60% %}

The `take` operations behave exactly like the corresponding `read` operations, except that the matching object is **removed from the space on one atomic operation. Two `take` operations will never return** copies of the same object, although if two equivalent objects were in the space the two `take` operations could return equivalent objects.

{%endcolumn%}
{%column width=35% %}
![write_return_prev-value.jpg](/attachment_files/POJO_take.png)
{%endcolumn%}
{%endsection%}


If a `take` returns a non-null value, the object has been removed from the space, possibly within a transaction. This modifies the claims to once-only retrieval: A take is considered to be successful only if all enclosing transactions commit successfully.
If a `RemoteException` is thrown, the take may or may not have been successful.
If an `UnusableEntryException` is thrown, the take `removed` the unusable object from the space.
If any other exception is thrown, the take did not occur, and no object was removed from the space.

With a `RemoteException`, an object can be removed from a space and yet never returned to the client that performed the take, thus losing the object in between.
In circumstances in which this is unacceptable, the take can be wrapped inside a transaction that is committed by the client when it has the requested object in hand.


{%note%}
If you would like to take objects from the space in the same order they have been written into the space you should perform the take objects in a [FIFO mode](./fifo-support.html).

Taking an object from the space might generate [notifications](./notify-container.html) to registered objects/queries.
{%endnote%}

The take operation can be performed with the following options:

- Template matching
- By Id
- By IdQuery
- By SQLQuery

To learn more about the different options refer to [Querying the Space](./querying-the-space.html)

##### Examples:

The following example writes an `Employee` object into the space and removes it from the space :

{% highlight java %}
    Employee employee = new Employee("Last Name", new Integer(32));
    employee.setFirstName("first name");
    space.write(employee);

    // Take by template
    Employee template = new Employee(new Integer(32));
    Employee e = space.take(template);

    // Take by id
    Employee e = space.takeById(Employee.class, new Integer(32));

    // Take by IdQuery
    IdQuery<Employee> query = new IdQuery<Employee>(Employee.class,
    				new Integer(32));
    Employee e = space.take(query);

    // Take by SQLQuery
	SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
				"firstName='first name'");
	Employee e = space.take(query);
{% endhighlight %}



#### Take multiple

{%section%}
{%column width=55% %}
The GigaSpace interface provides simple way to perform bulk take operations. You may take large amount of objects in one call.
{%endcolumn%}
{%column width=40% %}
![write_return_prev-value.jpg](/attachment_files/POJO_take_multi.png)
{%endcolumn%}
{%endsection%}

{% info %}
To remove a batch of objects without returning these back into the client use `GigaSpace.clear(SQLQuery)`;
{%endinfo%}

##### Examples:

{% highlight java %}
   Employee emps[] = new Employee[2];
   emps[0] = new Employee("Last Name A", new Integer(31));
   emps[1] = new Employee("Last Name B", new Integer(32));

   space.writeMultiple(emps);

   // Take multiple by template
   Employee[] employees = space.takeMultiple(Employee.class);

   // Take multiple by SQLQuery
   SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
   				"lastName ='Last Name B'");
   Employee[] e = space.takeMultiple(query);

   // Take by Ids
   Integer[] ids = new Integer[] { 31, 32 };
   TakeByIdsResult<Employee> result = space.takeByIds(Employee.class,ids);
   Employee[] employees = result.getResultsArray();

   // Take by IdsQuery
   Integer[] ids = new Integer[] { 31, 32 };
   IdsQuery<Employee> query = new IdsQuery<Employee>(Employee.class, ids);
   TakeByIdsResult<Employee> result = space.takeByIds(query);
   Employee[] employees = result.getResultsArray();

{% endhighlight %}

{%note title=Here are few important considerations when using the batch operation: %}
-  boosts the performance, since it performs multiple operations using one call. This method returns the matching results in one result object back to the client. This allows the client and server to utilize the network bandwidth in an efficient manner. In some cases, this batch operation can be up to 10 times faster than multiple single based operations.
-  should be handled with care, since it can return a large data set (potentially all the space data). This might cause an out of memory error in the space and client process. You should use the [GSIterator](#Space Iterator) to return the result in batches (paging) in such cases.
-  should be performed with transactions - this allows the client to roll back the space to its initial state prior the operation was started, in case of a failure.
-  operation **dos not support timeout** operations. The simple way to achieve this is by calling the `read` operation first with the proper timeout, and if non-null values are returned, perform the batch operation.
-  in the event of a take error, DataAccessException will wrap a TakeMultipleException, accessible via DataAccessException.getRootCause().  [TakeMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/TakeMultipleException.html)

{%endnote%}

#### Take if exists
A takeIfExists operation will return a matching object, or a null if there is currently no matching object in the space.
If the only possible matches for the template have conflicting locks from one or more other transactions, the timeout value specifies how long the client is willing to wait for interfering transactions to settle before returning a value.
If at the end of that time no value can be returned that would not interfere with transactional state, null is returned.

##### Example:

{% highlight java %}
    Employee employee = new Employee("Last Name", new Integer(32));
	employee.setFirstName("first name");
	space.write(employee);

	SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
				"firstName='first name'");
	Employee e = space.takeIfExists(query);
{% endhighlight %}


#### Asynchronous Take

The GigaSpace interface supports asynchronous (non-blocking) take operations through the GigaSpace interface. It returns a [Future\<T\>](http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Future.html) object, where T is the type of the object the request returns. Future<T>.get() can be used to query the object to see if a result has been returned or not.

Alternatively, asyncTake also accept an implementation of [AsyncFutureListener](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/async/AsyncFutureListener.html), which will have its `AsyncFutureListener.onResult` method called when the result has been populated. This does not affect the return type of the `Future<T>`, but provides an additional mechanism for handling the asynchronous response.


##### Example:

{% highlight java %}
    Employee employee = new Employee("Last Name", new Integer(32));
    employee.setFirstName("first name");
 	space.write(employee);

 	Integer[] ids = new Integer[] { 31, 32 };
 	IdsQuery<Employee> query = new IdsQuery<Employee>(Employee.class, ids);
 	AsyncFuture<Employee> result = space.asyncTake(query);

 	try {
 	    Employee e = result.get();
 	} catch (InterruptedException e) {
 		e.printStackTrace();
 	} catch (ExecutionException e) {
 		e.printStackTrace();
 	}
{% endhighlight %}

#### Modifiers

The take operations can be configured with different modifiers.

##### Examples:
{%highlight java%}
	Employee template = new Employee();

    // Takes objects in a FIFO mode
 	Employee e = space.take(template, 0, TakeModifiers.FIFO);

    // Takes objects according to FIFO group
	Employee e = space.take(template, 0, TakeModifiers.FIFO_GROUPING_POLL);
{%endhighlight%}


For further details on each of the available modifiers see: [TakeModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/TakeModifiers.html)


{% togglecloak id=os-take %}**Method summary...**{% endtogglecloak %}
{% gcloak os-take %}

Take by template:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#take(T){%endjavaapi%}
{%highlight java%}
<T> T take(T template) throws DataAccessException
<T> T take(T template, long timeout, TakeModifiers modifiers)throws DataAccessException
.....
{%endhighlight%}

Take by Id:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#takeById(java.lang.Class,%20java.lang.Object){%endjavaapi%}
{%highlight java%}
<T> T takeById(Class<T> clazz, Object id) throws DataAccessException
<T> T takeById(Class<T> clazz, Object id, Object routing, long timeout, TakeModifiers modifiers)throws DataAccessException
.....
{%endhighlight%}

Take by ISpaceQuery:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#take(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> T take(ISpaceQuery<T> query, Object id)throws DataAccessException
<T> T take(ISpaceQuery<T> query, Object routing, long timeout, TakeModifiers modifiers)throws DataAccessException
....
{%endhighlight%}

Take multiple:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#takeMultiple(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> T[] takeMultiple(ISpaceQuery<T> query) throws DataAccessException
<T> T[] takeMultiple(ISpaceQuery<T> query, long timeout, TakeModifiers modifiers) throws DataAccessException
<T> T[] takeMultiple(T template) throws DataAccessException
<T> T[] takeMultiple(T template, long timeout, TakeModifiers modifiers) throws DataAccessException
<T> T[] takeMultiple(ISpaceQuery<T> template, int maxEntries, TakeModifiers modifiers) throws DataAccessException
...
{%endhighlight%}

Asynchronous take:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#asyncTake(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> AsyncFuture<T> asyncTake(T template) throws DataAccessException
<T> AsyncFuture<T> asyncTake(T template, long timeout, TakeModifiers modifiers, AsyncFutureListener<T> listener) throws DataAccessException
<T> AsyncFuture<T> asyncTake(ISpaceQuery<T> query)throws DataAccessException
<T> AsyncFuture<T> asyncTake(ISpaceQuery<T> query, long timeout, TakeModifiers modifiers, AsyncFutureListener<T> listener)throws DataAccessException
.....
{%endhighlight%}

Take if exists:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#takeIfExists(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> T takeIfExists(T template)throws DataAccessException
<T> T takeIfExistsById(Class<T> clazz, Object id)throws DataAccessException
<T> T takeIfExistsById(Class<T> clazz, Object id, Object routing, long timeout, TakeModifiers modifiers) throws DataAccessException
<T> T takeIfExistsById(IdQuery<T> query, long timeout, TakeModifiers modifiers) throws DataAccessException
....
{%endhighlight%}



{: .table .table-bordered}
| Modifier and Type | Description | Default | Unit|
|:-----|:------------|:--------|:----|
| T          | POJO, SpaceDocument|| |
|timeout     | Time to wait for the response| 0  |  milliseconds |
|query| [ISpaceQuery](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/query/ISpaceQuery.html)|      | |
|[AsyncFutureListener](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/async/AsyncFutureListener.html) |Allows to register for a callback on an AsyncFuture to be notified when a result arrives||
|[TakeModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/TakeModifiers.html)|Provides modifiers to customize the behavior of take operations | NONE  |  |

{%endgcloak%}