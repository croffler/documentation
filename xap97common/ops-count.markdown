
# The Count Operation


You can use `GigaSpace.count` to count objects in a space.


Examples:

{% highlight java %}
   GigaSpace space;

   // Count with Template
   Employee employee = new Employee("Last Name");
   int count = space.count(employee);

   // Count with SQLQuery
   String querystr	= "age > 30";
   SQLQuery query = new SQLQuery(Employee.class, querystr);
   int count = space.count(query);

   // Count with IdsQuery
   Integer[] ids = new Integer[] { 32, 33, 34 };
   IdsQuery<Employee> query = new IdsQuery<Employee>(Employee.class, ids);
   int count = space.count(query);

   // Count with Modifier
   SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
				"firstName='first name'");
    int count = space.count(query, CountModifiers.EXCLUSIVE_READ_LOCK);
{% endhighlight %}



{% togglecloak id=os-count %}**Method summary...**{% endtogglecloak %}
{% gcloak os-count %}

Count objects in space.{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#count(java.lang.Object){%endjavaapi%}

{%highlight java%}
int count(T entry) throws DataAccessException
int count(T entry, ClearModifiers modifiers) throws DataAccessException
int count(ISpaceQuery<T> query) throws DataAccessException
......

{%endhighlight%}

{: .table .table-bordered}
| Modifier and Type | Description | default |
|:-----|:------------|:-------- |
|T          | POJO, SpaceDocument||
|query         | SQLQuery, IdQuery||
|[CountModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/CountModifiers.html)|Provides modifiers to customize the behavior of the count operations | NONE  |
{% endgcloak  %}


