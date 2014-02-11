---
layout: post
title:  Metadata
categories:
parent: space-based-remoting.html
weight: 300
---

{% summary %}This section explains the different remoting metadata.{% endsummary %}




# RemotingService

{: .table .table-bordered}
|Class Annotation    | @RemotingService|
|Description         | Spring provides support for various remoting technologies. GigaSpaces uses the same concepts to provide remoting, using the space as the underlying protocol |
|Attribute Annotation| @ExecutorProxy  |
|Method argument     | @Routing |


{% togglecloak id=1 %}**Example**{% endtogglecloak %}
{% gcloak 1 %}
{%highlight java%}
// Service Implementation
@RemotingService
public class DataProcessor implements IDataProcessor {

    public Data processData(Data data) {
    	data.setProcessor(true);
    	return data;
    }
}

// Client remoting proxy
public class DataRemoting {

    @ExecutorProxy
    private IDataProcessor dataProcessor;

    // ...
}

// remote method with routing parameter
public interface MyService {

    void doSomething(@Routing int param1, int param2);
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./space-based-remoting.html{%endlearn%}


# ExecutorProxy

{: .table .table-bordered}
|Attribute Annotation| @ExecutorProxy  |
|Description         | Spring provides support for various remoting technologies. GigaSpaces uses the same concepts to provide remoting, using the space as the underlying protocol |


{% togglecloak id=2 %}**Example**{% endtogglecloak %}
{% gcloak 2 %}
{%highlight java%}
// Client remoting proxy
public class DataRemoting {

    @ExecutorProxy
    private IDataProcessor dataProcessor;

    // ...
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./space-based-remoting.html{%endlearn%}


# Routing

{: .table .table-bordered}
|Method argument     | @Routing |
|Description         | Spring provides support for various remoting technologies. GigaSpaces uses the same concepts to provide remoting, using the space as the underlying protocol |



{% togglecloak id=3 %}**Example**{% endtogglecloak %}
{% gcloak 3 %}
{%highlight java%}
// Service Implementation
@RemotingService

   // remote method with routing parameter
   public interface MyService {

    void doSomething(@Routing int param1, int param2);
}
{%endhighlight%}
{% endgcloak %}
{%learn%}./space-based-remoting.html{%endlearn%}