

# The Read Operation
{%section%}
{%column width=60% %}

The  read operations query the space for an object that matches the criteria provided.
If a match is found, a copy of the matching object is returned.
If no match is found, null is returned. Passing a null reference as the template will match any object.
{%endcolumn%}
{%column width=35% %}
![write_return_prev-value.jpg](/attachment_files/POJO_read.jpg)
{%endcolumn%}
{%endsection%}

Any matching object can be returned. Successive read requests with the same template may or may not return equivalent objects, even if no intervening modifications have been made to the space.
Each invocation of `read` may return a new object even if the same object is matched in the space.
If you would like to read objects in the same order they have been written into the space you should perform the read objects in a [FIFO mode](./fifo-support.html).

{% note %}
The `read` operation default timeout is `JavaSpace.NO_WAIT`.
{% endnote %}

The read operation can be performed with the following options:

- Template matching
- By Id
- By IdQuery
- By SQLQuery

To learn more about the different options refer to [Querying the Space](./querying-the-space.html)

##### Examples:

The following example writes an `Employee` object into the space and reads it back from the space :

{% highlight java %}
    Employee employee = new Employee("Last Name", new Integer(32));
    employee.setFirstName("first name");
    space.write(employee);

    // Read by template
    Employee template = new Employee(new Integer(32));
    Employee e = space.read(template);

    // Read by id
    Employee e = space.readById(Employee.class, new Integer(32));

    // Read by IdQuery
    IdQuery<Employee> query = new IdQuery<Employee>(Employee.class,
    				new Integer(32));
    Employee e = space.read(query);

    // Read by SQLQuery
	SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
				"firstName='first name'");
	Employee e = space.read(query);
{% endhighlight %}




#### Read multiple

{%section%}
{%column width=60% %}
The GigaSpace interface provides simple way to perform bulk read operations. You may read a large amount of objects in one call.
{%endcolumn%}
{%column width=35% %}
![write_return_prev-value.jpg](/attachment_files/POJO_read_multi.jpg)
{%endcolumn%}
{%endsection%}

##### Examples:

{% highlight java %}
   Employee emps[] = new Employee[2];
   emps[0] = new Employee("Last Name A", new Integer(31));
   emps[1] = new Employee("Last Name B", new Integer(32));

   space.writeMultiple(emps);

   // Read multiple by template
   Employee[] employees = space.readMultiple(Employee.class);

   // Read multiple by SQLQuery
   SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
   				"lastName ='Last Name B'");
   Employee[] e = space.readMultiple(query);

   // Read by Ids
   Integer[] ids = new Integer[] { 31, 32 };
   ReadByIdsResult<Employee> result = space.readByIds(Employee.class,ids);
   Employee[] employees = result.getResultsArray();

   // Read by IdsQuery
   Integer[] ids = new Integer[] { 31, 32 };
   IdsQuery<Employee> query = new IdsQuery<Employee>(Employee.class, ids);
   ReadByIdsResult<Employee> result = space.readByIds(query);
   Employee[] employees = result.getResultsArray();

{% endhighlight %}

{%note title=Here are few important considerations when using the batch operation: %}
- boosts the performance, since it perform multiple operations using one call. These methods returns the matching results in one result object back to the client. This allows the client and server to utilize the network bandwidth in an efficient manner. In some cases, these batch operations can be up to 10 times faster than multiple single based operations.
- should be handled with care, since they can return a large data set (potentially all the space data). This might cause an out of memory error in the space and client process. You should use the [GSIterator](#Space Iterator) to return the result in batches (paging) in such cases.
- **dos not support timeout** operations. The simple way to achieve this is by calling the `read` operation first with the proper timeout, and if non-null values are returned, perform the batch operation.
- Exception handling - operation many throw the following Exceptions. [ReadMultipleException](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/ReadMultipleException.html)
{%endnote%}


#### Read if exists
A readIfExists operation will return a matching object, or a null if there is currently no matching object in the space.
If the only possible matches for the template have conflicting locks from one or more other transactions, the timeout value specifies how long the client is willing to wait for interfering transactions to settle before returning a value.
If at the end of that time no value can be returned that would not interfere with transactional state, null is returned. Note that, due to the remote nature of the space, read and readIfExists may throw a RemoteException if the network or server fails prior to the timeout expiration.

##### Example:

{% highlight java %}
    Employee employee = new Employee("Last Name", new Integer(32));
	employee.setFirstName("first name");
	space.write(employee);

	SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
				"firstName='first name'");
	Employee e = space.readIfExists(query);
{% endhighlight %}


#### Asynchronous Read

The GigaSpace interface supports asynchronous (non-blocking) read operations through the GigaSpace interface. It returns a [Future\<T\>](http://download.oracle.com/javase/6/docs/api/java/util/concurrent/Future.html) object, where T is the type of the object the request returns. Future<T>.get() can be used to query the object to see if a result has been returned or not.

Alternatively, asyncRead also accept an implementation of [AsyncFutureListener](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/async/AsyncFutureListener.html), which will have its `AsyncFutureListener.onResult` method called when the result has been populated. This does not affect the return type of the `Future<T>`, but provides an additional mechanism for handling the asynchronous response.


##### Example:

{% highlight java %}
    Employee employee = new Employee("Last Name", new Integer(32));
    employee.setFirstName("first name");
 	space.write(employee);

 	Integer[] ids = new Integer[] { 31, 32 };
 	IdsQuery<Employee> query = new IdsQuery<Employee>(Employee.class, ids);
 	AsyncFuture<Employee> result = space.asyncRead(query);

    // This part of the code could be executed in a different Thread
 	try {
 	    Employee e = result.get();
 	} catch (InterruptedException e) {
 		e.printStackTrace();
 	} catch (ExecutionException e) {
 		e.printStackTrace();
 	}
{% endhighlight %}

#### Modifiers

The read operations can be configured with different modifiers.

##### Examples:
{%highlight java%}
	Employee template = new Employee();

    // Read objects in a FIFO mode
 	Employee e = space.read(template, 0, ReadModifiers.FIFO);

    // Dirty read
	Employee e = space.read(template, 0, ReadModifiers.DIRTY_READ);
{%endhighlight%}


For further details on each of the available modifiers see: [ReadModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/ReadModifiers.html)


{% togglecloak id=os-read %}**Method summary...**{% endtogglecloak %}
{% gcloak os-read %}

Read by template:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#read(T){%endjavaapi%}
{%highlight java%}
<T> T read(T template) throws DataAccessException
<T> T read(T template, long timeout, ReadModifiers modifiers)throws DataAccessException
.....
{%endhighlight%}

Read by Id:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#readById(java.lang.Class,%20java.lang.Object){%endjavaapi%}
{%highlight java%}
<T> T readById(Class<T> clazz, Object id) throws DataAccessException
<T> T readById(Class<T> clazz, Object id, Object routing, long timeout, ReadModifiers modifiers)throws DataAccessException
.....
{%endhighlight%}

Read by ISpaceQuery:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#read(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> T read(ISpaceQuery<T> query, Object id)throws DataAccessException
<T> T read(ISpaceQuery<T> query, Object routing, long timeout, ReadModifiers modifiers)throws DataAccessException
....
{%endhighlight%}

Read multiple:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#readMultiple(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> T[] readMultiple(ISpaceQuery<T> query) throws DataAccessException
<T> T[] readMultiple(ISpaceQuery<T> query, long timeout, ReadModifiers modifiers) throws DataAccessException
<T> T[] readMultiple(T template) throws DataAccessException
<T> T[] readMultiple(T template, long timeout, ReadModifiers modifiers) throws DataAccessException
<T> T[] readMultiple(ISpaceQuery<T> template, int maxEntries, ReadModifiers modifiers) throws DataAccessException
...
{%endhighlight%}

Asynchronous Read:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#asyncRead(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> AsyncFuture<T> asyncRead(T template) throws DataAccessException
<T> AsyncFuture<T> asyncRead(T template, long timeout, ReadModifiers modifiers, AsyncFutureListener<T> listener) throws DataAccessException
<T> AsyncFuture<T> asyncRead(ISpaceQuery<T> query)throws DataAccessException
<T> AsyncFuture<T> asyncRead(ISpaceQuery<T> query, long timeout, ReadModifiers modifiers, AsyncFutureListener<T> listener)throws DataAccessException
.....
{%endhighlight%}

Read if exists:{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#readIfExists(com.gigaspaces.query.ISpaceQuery){%endjavaapi%}
{%highlight java%}
<T> T readIfExists(T template)throws DataAccessException
<T> T readIfExistsById(Class<T> clazz, Object id)throws DataAccessException
<T> T readIfExistsById(Class<T> clazz, Object id, Object routing, long timeout, ReadModifiers modifiers) throws DataAccessException
<T> T readIfExistsById(IdQuery<T> query, long timeout, ReadModifiers modifiers) throws DataAccessException
....
{%endhighlight%}



{: .table .table-bordered}
| Modifier and Type | Description | Default | Unit|
|:-----|:------------|:--------|:----|
| T          | POJO, SpaceDocument|| |
|timeout     | Time to wait for the response| 0  |  milliseconds |
|query| [ISpaceQuery](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/query/ISpaceQuery.html)|      | |
|[AsyncFutureListener](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/async/AsyncFutureListener.html) |Allows to register for a callback on an AsyncFuture to be notified when a result arrives||
|[ReadModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/ReadModifiers.html)|Provides modifiers to customize the behavior of read operations | NONE  |  |

{%endgcloak%}