
# The Clear Operation

{%section%}
{%column width=60% %}
You can use `GigaSpace.clear` to remove objects from the space. When using the clear operation no object/objects are returned.
{%endcolumn%}
{%column width=35% %}
![POJO_clear.jpg](/attachment_files/POJO_clear.jpg)
{%endcolumn%}
{%endsection%}

Examples:

{% highlight java %}
   GigaSpace space;

   // Clear by Template
   Employee employee = new Employee("Last Name", new Integer(32));
   space.clear(employee);

   // Clear by SQLQuery
   String querystr	= "age > 30";
   SQLQuery query = new SQLQuery(Employee.class, querystr);
   space.clear(query);

   // Clear by IdQuery
   IdQuery<Employee> query = new IdQuery<Employee>(Employee.class,
   				new Integer(32));
   space.clear(query);

   // Clear with Modifier
   SQLQuery<Employee> query = new SQLQuery<Employee>(Employee.class,
				"firstName='first name'");
   space.clear(query, ClearModifiers.EVICT_ONLY);
{% endhighlight %}



{% togglecloak id=os-clear %}**Method summary...**{% endtogglecloak %}
{% gcloak os-clear %}

Clears objects from space.{%javaapi%}http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/org/openspaces/core/GigaSpace.html#clear(java.lang.Object){%endjavaapi%}

{%highlight java%}
void clear(T entry) throws DataAccessException
void clear(T entry, ClearModifiers modifiers) throws DataAccessException
void clear(ISpaceQuery<T> query) throws DataAccessException
......

{%endhighlight%}

{: .table .table-bordered}
| Modifier and Type | Description | default |
|:-----|:------------|:-------- |
|T          | POJO, SpaceDocument||
|query         | SQLQuery, IdQuery||
|[ClearModifiers](http://www.gigaspaces.com/docs/JavaDoc{% currentversion %}/com/gigaspaces/client/ClearModifiers.html)|Provides modifiers to customize the behavior of the clear operations | NONE  |
{% endgcloak  %}


