
# The Change Operation
{%section%}
{%column width=60% %}
The [GigaSpace.change](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?org/openspaces/core/GigaSpace.html) and the [ChangeSet](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ChangeSet.html) allows updating existing objects in space, by specifying only the required change instead of passing the entire updated object. Thus reducing required network traffic between the client and the space, and the network traffic generated from replicating the changes between the space instances (e.g between the primary space instance and its backup).
{%endcolumn%}
{%column width=35% %}
![change-api.jpg](/attachment_files/change-api.jpg)
{%endcolumn%}
{%endsection%}

Moreover, using this API also can prevent the need of reading the existing object prior to the change operation because the change operation can specify how to change the existing property without knowing its current value. For instance, implementing atomic [Counters](./counters.html) can be done by increasing a counter property of an integer property by some delta.
Another example would be to add a value to a collection and so on.
The change API supports [transactions](./transaction-management.html) in the same way the other space operation supports it, using a transactional `GigaSpace` instance.


The change operation may receive any [query template](./querying-the-space.html) for matching a single or multiple objects that needs to be changed by the operation.


#### Example

The following example demonstrates how to increase the property 'count' in a an object of type 'WordCount' with id 'the' by one.

{% highlight java %}
   GigaSpace space = // ... obtain a space reference
   String id = "myID";
   IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id, routing);
   space.change(idQuery, new ChangeSet().increment("count", 1));
{% endhighlight %}


#### The Change Set

The change operation requires a [ChangeSet](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/ChangeSet.html) which described the changes that needs to be done once locating the object specified by the query template.
The `ChangeSet` contains a predefined set of operations that can be invoked to alter the object, the set may contain one or more changes that will be applied sequentially to the object.
Each specified change may operate on any level of properties of the specified object, this is defined by specifying the path to the property that needs to be changed where '.' in the path specifies
that this change is done on a nested property. For instance:

{% highlight java %}
@SpaceClass
public class Account
{
  ...
  @SpaceId
  Uuid getId();
  Balance getBalance();
  void setBalance(Balance balance){...}
}

public class Balance
{
  private double euro;
  private double usDollar;
  ...
  public double getEuro();
  public void setEuro(double euro) { this.euro = euro; }
  public double getUsDollar();
  public void setUsDollar(double usDollar) { this.usDollar = usDollar; }
}
{% endhighlight %}

{% highlight java %}
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing);
space.change(idQuery, new ChangeSet().increment("balance.euro", 5.2D));
{% endhighlight %}

##### Change Path Specification

Each operation in the change set acts on a specified string path. This path points to the property that needs to be changed and it has the following semantic:

1. **First level property** - A path with no '.' character in it points to a first level property, If the property specified by this path is not part of the Object it will be treated as a dynamic property (see [Dynamic Properties](./dynamic-properties.html)) if the object does not support dynamic properties, an exception will be generated.
1. **Nested property** - A path that contains '.' character is considered a path to a nested property, the location process of the final property which needs to be changed is done recursively by activating the properties, specified by the split of the path using the '.' character, one at a time until reaching the targeted end property.
1. **Nested Map property** - A path that contains '.' may also point to keys inside a map as, meaning the following path - 'attributes.color' will look for key named 'color' if the property named 'attribute' in the object is actually a map. This affects nested properties as well.

The following demonstrates how the path works with a map property instead of concrete properties:

{% highlight java %}
@SpaceClass
public class Account
{
  ...
  @SpaceId
  Uuid getId();
  Map<String, double> getBalance();
  void setBalance(Map<String, double>  balance){...}
}
{% endhighlight %}

{% highlight java %}
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing);
space.change(idQuery, new ChangeSet().increment("balance.euro", 5.2D));
{% endhighlight %}

In this case the key euro inside the map behind the balance will be increased by 5.2.



{% togglecloak id=os-change-options %}**Available Change Set Operations...**{% endtogglecloak %}
{% gcloak os-change-options %}

{: .table .table-bordered}
|Operation Name|Description|Semantics|
|:-------------|:----------|:--------|
|**set**|sets a property value|sets value of the given property|
|**unset**|unsets a property value|If the property is a fixed property, it will be set with null (null value for primitives), if it is a dynamic property it will be removed from the dynamic properties, note that for dynamic properties this is **not** equivalent to the set operation with `null` value|
|**increment**|increase a numeric property by the given delta|This change may operate on a numeric property only (byte,short,int,long,float,double or their corresponding Boxed variation), if the property does not exists, the delta will be set as its initial state|
|**decrement**|decrease a numeric property by the given delta|This change may operate on a numeric property only (byte,short,int,long,float,double or their corresponding Boxed variation), if the property does not exists, the -delta will be set as its initial state|
|**addToCollection**|adds an item to a collection property|The item is added to the collection by applying the `Collection.add` operation with the given item on the collection behind the property, if the property do not exists an exception will be thrown|
|**addAllToCollection**|adds a list of items to a collection property|The items are added to the collection by applying the `Collection.addAll` operation with the given items on the collection behind the property, if the property do not exists an exception will be thrown|
|**removeFromCollection**|removes an item from a collection property|The item is removed from the collection by applying the `Collection.remove` operation with the given item on the collection behind the property, if the property do not exists an exception will be thrown|
|**putInMap**|puts a key value pair in a map property|The key and value are put into a map by applying the `Map.put` operation with the given key and value on the map behind the property, if the property do not exists an exception will be thrown|
|**removeFromMap**|removes a key and its associated value from a map property|The key is removed from a map by applying the `Map.remove` operation with the given key on the map behind the property, if the property do not exists an exception will be thrown|

{% endgcloak %}

# Using Change with the Embedded model

With the [embedded model](./modeling-your-data.html#Embedded vs. Non-Embedded Relationships), updating (as well adding or removing) a nested collection with large number of elements **must use the change API** since the default behavior would be to replicate the entire space object and its nested collection elements from the primary to the backup (or other replica primary copies when using the sync-replicate or the async-replicated cluster schema).
The Change API reduces the CPU utilization at the primary side, reduce the serialization overhead and reduce the garbage collection activity both at the primary and backup. This improves the overall system stability significantly.

# Change Result

The change operations returns a [ChangeResult](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/index.html?com/gigaspaces/client/ChangeResult.html) object that provides information regarding the change operation affect.

{%comment%}
{% highlight java %}
public interface ChangeResult<T>
        extends Serializable
{
    /**
     * Returns a collection of {@link ChangedEntryDetails} of the changed
     * entries. <note>This is only supported if the
     * {@link ChangeModifiers#RETURN_DETAILED_RESULTS} modifier was used,
     * otherwise this method will throw unsupported operation exception.
     *
     * @throws UnsupportedOperationException if the corresponding change
     *             operation was not used with the
     *             {@link ChangeModifiers#RETURN_DETAILED_RESULTS} modifier.
     */
    Collection<ChangedEntryDetails<T>> getResults();

    /**
     * Returns the number of changed entries
     */
    int getNumberOfChangedEntries();
}
{% endhighlight %}
{%endcomment%}

{% highlight java %}
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing);
ChangeResult<Account> changeResult = space.change(idQuery, new ChangeSet().increment("balance.euro", 5.2D));
if (changeResult.getNumberOfChangedEntries() == 0)
{
  // ... handle no entry found for change
}
{% endhighlight %}

The `ChangeResult` contains the `getNumberOfChangedEntries` which specifies how many objects where changed by this operation where 0 means none were changed. The `getResults` property gives further details about the objects that were actually changes by providing a collection which gives details for each of the objects that were changed, such as their id and version after the change took affect. By default, in order to reduce network overhead, calling the getResults will throw `UnsupportedOperationException`. In order to get the more detailed result, the `ChangeModifiers.RETURN_DETAILED_RESULTS` should be passed to the `change` operation.


{% refer %}For more information please read [Change API Advanced](./change-api-advanced.html). {% endrefer %}

# ChangeException

Upon any error a `ChangeException` will be thrown containing the following details:

{%comment%}
{% highlight java %}
public class ChangeException extends InvalidDataAccessResourceUsageException
{

    /**
     * Returns the number of successfully changes.
     */
    public int getNumSuccesfullChanges()

    /**
     * Returns the successfully done changes.
     */
    public Collection<ChangedEntryDetails<?>> getSuccesfullChanges()

    /**
     * Returns the entries that failed to change result.
     */
    public Collection<FailedChangedEntryDetails> getFailedChanges()

    /**
     * Returns the failed changes.
     */
    public Collection<Throwable> getErrors()

}
{% endhighlight %}
{%endcomment%}


The `getNumSuccesfullChanges` property contains the number of entries that were successfully changed.
The `getSuccesfullChanges` property contains details for objects that were successfully changed just like the `ChangeResult.getResults` property. This property can only be used if the change operation was executed using the `ChangeModifiers.RETURN_DETAILED_RESULTS` modifier.
The `getFailedChanges` property contains details for objects that failed being changed, the details contains information about id, version and the actual cause for failure.
The `getErrors` property contains general failure reason for executing the change operation which do not apply to a specific object, such as not being able to access the space.

#### Multiple Changes in One Operation

One may apply multiple changes in one `change` operation by setting up multiple operation in the change set, this is done simply by chaining changes as follows:

{% highlight java %}
GigaSpace space = // ... obtain a space reference
IdQuery<MyPojo> idQuery = new IdQuery<MyPojo>(MyPojo.class, id, routing);
space.change(idQuery, new ChangeSet().increment("someIntProperty", 1)
                                     .set("someStringProperty", "newStringValue)
                                     .putInMap("someNestedProperty.someMapProperty", "myKey", 2));
{% endhighlight %}

The changes will applied to the object sequentially (and atomically) keeping the order applied on the `ChangeSet`.

#### Changing the Object's Lease

By default, the change operation will not modify the existing remaining lease of the changed entries. In order to change the lease, the new lease should be specified on the `ChangeSet` using the `lease` operation.

{% highlight java %}
GigaSpace space = // ... obtain a space reference
space.change(idQuery, new ChangeSet().lease(1000)...);
{% endhighlight %}

The lease can be changed as part of other changes applied to the object, as well as having the `ChangeSet` include only the lease modification without any property changes.
The lease time specified will override the existing lease with the new value relative to the current time while ignoring the current lease.
The above example will set the lease of the changed object to be one second from the time the change operation took affect.

#### Change with Timeout

A timeout can be passed to the `change` operation, this timeout will only be used if any of the objects that needs to be changed is locked under a transaction which is not from the
current thread context. In that case, all objects which are not locked will be changed and the operation will block until either one of the two happens, which ever comes first:

1. the transaction lock is released - in that case the the change operation will be applied on the objects that were locked but now available.
1. the timeout elapsed - the change operation will return with an exception. Like all other failures, the exception will be a `ChangeException` which will contain the successful changes, and all the objects that remained locked when the timeout elapsed will be part of the `getFailedChanges` property of the exception, each with a failure reason of `UpdateOperationTimeoutException`.

If there were no matching objects for the specified template, the operation will return immediately without waiting for the timeout to elapse. This is similar to the `(read/take)IfExists` operation semantic.

{% highlight java %}
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing);
long timeout = 1000; //1 seconds
try
{
  space.change(idQuery, new ChangeSet().increment("balance.euro", 5.2D), timeout);
}
catch(ChangeException e)
{
  if (!e.getFailedChanges().isEmpty())
  {
    for(FailedChangedEntryDetails failedChangedEntry : e.getFailedChanges())
    {
      if (id.equals(failedChangedEntry.getId()) && failedChangedEntry.getCause() instanceof UpdateOperationTimeoutException)
      {
       //.. Indicate the object is still locked under a transaction, maybe retry the operation?
      }
    }
  }
}
{% endhighlight %}

#### Change and Optimistic Locking

The `change` operation has the same semantics as regular space `update` operation when it comes to [Optimistic Locking](./optimistic-locking.html). It will increase the version of the changed object and the expected version can be specified in the id query when optimistic locking is needed.

{% highlight java %}
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
Object routing = id; // In our case the space routing property is the space id property.
int version = 2; // We only want to change the object if the object's version in the space is 2.
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing, version);
try
{
  space.change(idQuery, new ChangeSet().increment("balance.euro", 5.2D), timeout);
}
catch(ChangeException e)
{
  if (!e.getFailedChanges().isEmpty())
  {
    for(FailedChangedEntryDetails failedChangedEntry : e.getFailedChanges())
    {
      if (id.equals(failedChangedEntry .getId()) failedChangedEntry .getCause() instanceof SpaceOptimisticLockingFailureException)
      {
        //.. Indicate optimistic locking failure, get the updated version for instance and maybe read updated object and retry?
        int updatedVersion = failedChangedEntry.getVersion();
      }
    }
  }
}
{% endhighlight %}

{% exclamation %} In order to prevent constructor overload ambiguity, when using id query with version, the space routing property needs to be specified as well. If the object has no space routing then its space id property is the routing property and it should be used as shown in the previous example.

#### Change and Notifications

Change will be delivered as a regular update notification, with the state of the object after the change was applied.

#### Change Modifiers

The following modifiers can be used with the change operation

1. **`ChangeModifiers.RETURN_DETAILED_RESULTS`** - Provide details change result containing more information about the objects that were changed, requires more network traffic.
1. **`ChangeModifiers.ONE_WAY`** - Change is executed in one way mode, which means the operation will not wait for the change operation to reach the server, the result will always be null and
there is no guarantee whether the operation succeeded or not as this mode does not guarantee any exceptions upon failure. The only guarantee is that the operation was successfully written to the local network buffer.

1. **`ChangeModifiers.MEMORY_ONLY_SEARCH`** - Search for matching entries in cache memory only (do not use the underlying external data source). However, any changes done on the matches entries
will propagate to the underlying external data source.

#### Asynchronous Change

The `change` operation has also an asynchronous API, in which the operation is dispatched to the server and the result is returned asynchronously via a listener or a future.

![changeAsync-api.jpg](/attachment_files/changeAsync-api.jpg)

This operation behaves exactly as the synchronous `change` except for the asynchronous result and it follows java standard asynchronous semantics.

{% highlight java %}
//Using future to get the result
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing);
Future<ChangeResult<Account>> future = space.asyncChange(idQuery, new ChangeSet().increment("balance.euro", 5.2D));
// ... do some other stuff
ChangeResult<Account> changeResult = future.get();
{% endhighlight %}

{% highlight java %}
//Using a listener to handle the result
GigaSpace space = // ... obtain a space reference
Uuid id = ...;
IdQuery<Account> idQuery = new IdQuery<Account>(Account.class, id, routing);
AsyncFutureListener<ChangeResult<Account>> myListener = new AsyncFutureListener<ChangeResult<Account>>()
  {
    void onResult(AsyncResult<Account> result)
    {
      if (result.getException() != null)
      {
        // ... Handle exception
      }
      else
      {
        ChangeResult<Account> changeResult = result.getResult();
        // ... handle result
      }
    }
  }
space.asyncChange(idQuery, new ChangeSet().increment("balance.euro", 5.2D), myListener);
{% endhighlight %}

# Change and SpaceSynchronizationEndpoint

A SpaceSynchronizationEndpoint implementation could support change operations and make use of lighter replication between the space and the mirror.
For more information on how to implement it please read [Change API Advanced](./change-api-advanced.html)

# Change and Replication Filter

Change passes through [Replication Filter](./cluster-replication-filters.html) like other operations and for example can be discarded on replication level.

{% refer %}For more information on how to handle change in replication filters please read to [Change API Advanced](./change-api-advanced.html).{% endrefer %}

# Change Extension

See [Change Extension](./change-extension.html) which provide utility methods for common usage patterns.

# Considerations

1. When replicated to a gateway and a conflict occurs, change operation only supports the built in `abort` resolution as `override` in change case may result with an inconsistent state of the object.
1. The change operation is converted to a regular update when delegated to a synchronous data source.


#### Modifiers

For further details on each of the available modifiers see: [WriteModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/WriteModifiers.html)

{%note%}
Writing an object into a space might generate [notifications](./notify-container.html) to registered objects.
{%endnote%}

{% togglecloak id=os-change %}**Method summary...**{% endtogglecloak %}
{% gcloak os-change %}

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


