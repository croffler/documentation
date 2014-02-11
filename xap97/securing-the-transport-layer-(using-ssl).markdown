---
layout: post
title:  Securing the Transport Layer (using SSL)
categories: XAP97
parent: securing-xap-components.html
weight: 300
---

{% summary %}GigaSpaces provides a generic network filter that also provides SSL support, through an SSL communication filter.{% endsummary %}

{% refer %}[How to Set GigaSpaces Over a Firewall](./how-to-set-gigaspaces-over-a-firewall.html){% endrefer %}

# Overview

GigaSpaces provides two types of communication filter:

- Stream-based filter - for a protocol like ZIP. This type of filter does not support a handshake phase.
- Block-based filter - for encryption network filters. These filters do support a handshake phase.

{% infosign %} For now, GigaSpaces supports only one communication filter, and this filter is applied to all the connections in the JVM.

# Usage

The way to load and enable the communication filter, is by setting the system property `com.gs.lrmi.filter.factory`. The value should be the `communication filter factory` class name.

For example, to use an SSL communication filter, run GigaSpaces with:

{% highlight java %}
-Dcom.gs.lrmi.filter.factory=com.gigaspaces.lrmi.nio.filters.SSLFilterFactory
{% endhighlight %}

# Default SSLFilterFactory

{% refer %}[GigaSpaces Java API Documentation](/api_documentation/index.html){% endrefer %}

Since some types of communication filters are not symmetric regarding the client and server, the class [`SSLFilterFactory`](http://www.gigaspaces.com/docs/JavaDoc{%currentversion%}/com/gigaspaces/lrmi/nio/filters/SSLFilterFactory.html) has 2 methods: one to create the communication filter for the client side, and the other for the server side.

- public IOFilter [`createClientFilter()`](http://www.gigaspaces.com/docs/JavaDoc{%currentversion%}/com/gigaspaces/lrmi/nio/filters/SSLFilterFactory.html#createClientFilter) throws Exception;

- public IOFilter [`createServerFilter()`](http://www.gigaspaces.com/docs/JavaDoc{%currentversion%}/com/gigaspaces/lrmi/nio/filters/SSLFilterFactory.html#createServerFilter) throws Exception;

If the communication filter needs its own parameters, it can acquire them by directly reading system properties. For example, the supplied SSLFilter needs to get the keystore file, and the password to this file.

It uses the following system properties to get them:

{% highlight java %}
-Dcom.gs.lrmi.filter.security.keystore=keystore.ks
-Dcom.gs.lrmi.filter.security.password=password
{% endhighlight %}

The keystore file is loaded from somewhere in the classpath.

The provided SSLFilter uses keystore type JKS, with key management method SunX509.

{% info %}
Please refer to the JavaDocs for more details about the reference classes:

- [com.gigaspaces.lrmi.nio.filters.IOSSLFilter](http://www.gigaspaces.com/docs/JavaDoc{%currentversion%}/com/gigaspaces/lrmi/nio/filters/IOSSLFilter.html)

- [com.gigaspaces.lrmi.nio.filters.IOStreamCompressionFilter](http://www.gigaspaces.com/docs/JavaDoc{%currentversion%}/com/gigaspaces/lrmi/nio/filters/IOStreamCompressionFilter.html)

{%endinfo%}

Code snippet of the space server.

{% highlight java %}
public class SSLServer {
	public static void main(String [] args) throws Exception{
		UrlSpaceConfigurer configurer = new UrlSpaceConfigurer("/./SSLSpace").
                lookupGroups("ssl_example_group");
		GigaSpace gigaSpace = new GigaSpaceConfigurer(configurer).gigaSpace();
	}
}
{% endhighlight %}

Code snippet of the space client.

{% highlight java %}
public class SSLClient {
	public static void main(String [] args) throws Exception{
		UrlSpaceConfigurer configurer =
                  new UrlSpaceConfigurer("jini://localhost/*/SSLSpace).
                  lookupGroups("ssl_example_group");
		GigaSpace remoteSpace = new GigaSpaceConfigurer(configurer).gigaSpace();

		AnEntry entry = new AnEntry();
		entry.key = "first";
		entry.payload = "first value";
		remoteSpace.write(entry);
		AnEntry value = remoteSpace.read(new AnEntry());
		System.out.println(value.payload);
	}

	public static class AnEntry implements Entry{
		private static final long serialVersionUID = 1L;

		public AnEntry() {
		}
		public String key;
		public String payload;
	}
}
{% endhighlight %}

As you can see, until now there is nothing special in the code -- it is the same code as if the SSL was not used.
However, when you wish to run this code with SSL encryption, you should run it with the following system properties (both server and client), and have the [keystore](Securing the Transport Layer (using SSL)^keystore.ks) anywere in the classpath (both server and client).

{% highlight java %}
-Dcom.gs.lrmi.filter.factory=com.gigaspaces.lrmi.nio.filters.SSLFilterFactory
-Dcom.gs.lrmi.filter.security.keystore=keystore.ks
-Dcom.gs.lrmi.filter.security.password=password
{% endhighlight %}

{% tip %}
With production environment you should have the SSLFilterFactory password (or any other secured user access information) protected by passing its value at the deploy time into the pu.xml (where the actual property using a variable) or at the start-up time as an argument to a wrapper script starting the GigaSpaces agent and not place such secured data on file.
{% endtip %}

The indication that SSL is used is the message:

{% highlight java %}
Communication Filters Information:
	CommunicationFilterFactory: com.gigaspaces.lrmi.nio.filters.SSLFilterFactory
{% endhighlight %}

