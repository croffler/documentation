---
layout: post
title:  Metadata
categories: XAP97
parent: task-execution-over-the-space.html
weight: 300
---

{% summary %}This section explains the different Task metadata.{% endsummary %}




# Task Execution

{: .table .table-bordered}
|Attribute Annotation|@TaskGigaSpace   |
|Description         | This annotation injects a clustered proxy into the Task implementation. This is useful when the Task should access other partitions.   |


{% togglecloak id=4 %}**Example**{% endtogglecloak %}
{% gcloak 4 %}
{%highlight java%}
public class MyTask implements Task<Integer>  {

    @TaskGigaSpace
    private transient GigaSpace colocatedSpace;
    private transient GigaSpace clusteredSpace;

    public MyTask() {
    }
....
}
{%endhighlight%}
{% endgcloak %}

{%learn%}./task-execution-over-the-space.html{%endlearn%}


# Task Routing

{: .table .table-bordered}
|Method Annotation|@SpaceRouting  |
|Description         | This annotation selects the routing value. In case it is a POJO defined with a @SpaceRouting on one of its properties, the value of that property will be used as the routing information when passed as a parameter.   |


{% togglecloak id=5 %}**Example**{% endtogglecloak %}
{% gcloak 5 %}
{%highlight java%}
public class MyTask implements Task<Integer>  {

    @SpaceRouting
    public Integer routing() {
       return this.value;
    }
....
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./task-execution-over-the-space.html{%endlearn%}