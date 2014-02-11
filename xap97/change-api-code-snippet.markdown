

The `GigaSpace.change` operation allows you to change a specific content of an existing object(s) in the space. Unlike the write operation that may update an existing object, the `change` operation does not require reading the object and later sending its updated copy with the operation back to the space.

{% indent %}
![changeAPI.jpg](/attachment_files/changeAPI.jpg)
{% endindent %}

Unlike the write operation `PARTIAL_UPDATE` modifier, you may use the `change` operation to update a specific field value without retrieving its prior value. This is very helpful when incrementing or decrementing a numeric field, updating value of nested field or adding an item to a collection field without having to send the entire updated collection to the space.

The `change` operation is designed to boost the application performance since only the required "delta" is sent to the space. When having a replica space deployed, only the change operation is replicated. For example, when having a collection field, using the `change` operation reduces the need to send the entire updated collection as only the added member is replicated.

The following example incrementing an integer field within an existing space object by 1 using the `change` operation.

{% highlight java %}
String id = "KEY_123456789";
IdQuery<WordCount> idQuery = new IdQuery<WordCount>(WordCount.class, id);
space.change(idQuery, new ChangeSet().increment("count", 1));
{% endhighlight %}

Upon any failure, the change operation will throw `ChangeException` which will contain full details regarding the failure.

{% refer %}Refer to [Change API](./change-api.html) for full details regarding the change operation{% endrefer %}

