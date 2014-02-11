---
layout: post
title:  REST API
categories: XAP97
parent: interoperability.html
weight: 200
---


{% summary  %}The REST API exposing HTTP based interface to the Space.{% endsummary %}

# Overview

{% section %}
{% column %}
The REST API exposing HTTP based interface Space. It is leveraging the [GigaSpace API](./the-gigaspace-interface.html). It support the following methods:

1. GET - can be used to perform a readByID or a readMultiple action by a space query.
1. POST - can be used to perform a write / writeMultiple action.
1. PUT - can be used to perform a single or multiple write or update actions.
1. DELETE - can be used to perform take / takeMultiple actions either by ID or by a space query.

{% warning %}
POST is mapped to a WriteOnly action. An exception will be thrown when trying to write an object which already exists in space.
{% endwarning %}

{% endcolumn %}
{% column %}
![web-services.jpg](/attachment_files/web-services.jpg)
{% endcolumn %}

{% endsection %}

## Examples

- writeMultiple

{% highlight java %}
curl -XPOST -d '[{"id":"1", "data":"testdata", "data2":"common", "nestedData" : {"nestedKey1":"nestedValue1"`,
{"id":"2", "data":"testdata2", "data2":"common", "nestedData" : {"nestedKey2":"nestedValue2"`,
{"id":"3", "data":"testdata3", "data2":"common", "nestedData" : {"nestedKey3":"nestedValue3"`]' http://localhost:8080/WebApp/rest/data/Item
{% endhighlight %}

- readMultiple

{% highlight java %}
[http://localhost:8080/WebApp/rest/data/Item/_criteria?q=data2='common]'
[http://localhost:8080/WebApp/rest/data/Item/_criteria?q=id=%271%27%20or%20id=%272%27%20or%20id=%273%27]
{% endhighlight %}

The url is encoded, the query is "id='1' or id='2' or id='3'".

- readById

{% highlight java %}
[http://localhost:8080/WebApp/rest/data/Item/1]
[http://localhost:8080/WebApp/rest/data/Item/2]
[http://localhost:8080/WebApp/rest/data/Item/3]
{% endhighlight %}

- updateMultiple

{% highlight java %}
curl -XPUT -d '[{"id":"1", "data":"testdata", "data2":"commonUpdated", "nestedData" : {"nestedKey1":"nestedValue1"`,
{"id":"2", "data":"testdata2", "data2":"commonUpdated", "nestedData" : {"nestedKey2":"nestedValue2"`,
{"id":"3", "data":"testdata3", "data2":"commonUpdated", "nestedData" : {"nestedKey3":"nestedValue3"`]' http://localhost:8080/WebApp/rest/data/Item
{% endhighlight %}

See that data2 field is updated:

{% highlight java %}
[http://localhost:8080/WebApp/rest/data/Item/_criteria?q=data2='commonUpdated']
{% endhighlight %}

Single nested update:

{% highlight java %}
curl -XPUT -d '{"id":"1", "data":"testdata", "data2":"commonUpdated", "nestedData" :
{"nestedKey1":"nestedValue1Updated"`' http://localhost:8080/WebApp/rest/data/Item
{% endhighlight %}

See that Item1 nested field is updated:

{% highlight java %}
http://localhost:8080/WebApp/rest/data/Item/1
{% endhighlight %}

- takeMultiple (url is encoded, the query is "id=1 or id=2")

{% highlight java %}
curl -XDELETE http://localhost:8080/WebApp/rest/data/Item/_criteria?q=id=%271%27%20or%20id=%272%27
{% endhighlight %}

See that only Item3 remains:

{% highlight java %}
[http://localhost:8080/WebApp/rest/data/Item/_criteria?q=id=%271%27%20or%20id=%272%27%20or%20id=%273%27]
{% endhighlight %}

- takeById

{% highlight java %}
curl -XDELETE "http://localhost:8080/WebApp/rest/data/Item/3"
{% endhighlight %}

See that Item3 does not exists:

{% highlight java %}
[http://localhost:8080/WebApp/rest/data/Item/_criteria?q=id=%271%27%20or%20id=%272%27%20or%20id=%273%27]
{% endhighlight %}

# Setup Instructions

1.Download the project from the [github repository](https://github.com/OpenSpaces/RESTData)

2.Edit "/RESTData/src/main/webapp/WEB-INF/config.properties"? to include your space url, for example: `spaceUrl=jini://*/*/testSpace?groups=restdata`

3.Package the project using maven: "mvn package". This will run the unit tests and package the project to a war file located at /target/RESTData.war

4.[Deploy](./deploy-command-line-interface.html) the war file.
