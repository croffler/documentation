# J2EE vs. XAP

Here is a simple mapping between the J2EE common components and equivalent XAP components:

{: .table .table-bordered}
|Component|J2EE|XAP|
|:--------|:---|:--|
|Persistency|JPA|[Hibernate]({%latestjavaurl%}/hibernate-space-persistency.html), [JPA]({%latestjavaurl%}/jpa-api.html)|
|Messaging|JMS,MDB|[JMS]({%latestjavaurl%}/jms-api-support.html), [Polling Container]({%latestjavaurl%}/polling-container.html), [Notify Container]({%latestjavaurl%}/notify-container.html) , [Native Messaging API]({%latestjavaurl%}/session-based-messaging-api.html), MDB {% star %} |
|Security|JAAS, SSL|[Spring Security]({%latestjavaurl%}/spring-security-bridge.html), [SSL]({%latestjavaurl%}/securing-the-transport-layer-(using-ssl).html)|
|Web Session Management|HttpSession|[HttpSession (via Jetty)]({%latestjavaurl%}/http-session-management.html)|
|Transaction Management|JTA|[Spring Transaction via Jini Transaction Manager]({%latestjavaurl%}/transaction-management.html)|
|Data Access|JDBC , Session Bean (Stateless or Stateful), Entity Bean|[JDBC]({%latestjavaurl%}/jdbc-driver.html), [Space]({%latestjavaurl%}/the-gigaspace-interface.html), [JPA]({%latestjavaurl%}/jpa-api.html) , Session Bean(Stateless or Stateful) {% star %}, Entity Bean {% star %}|
|Remoting|EJB, IIOP, RMI|[Spring remoting over LRMI]({%latestjavaurl%}/executor-based-remoting.html) , EJB {% star %}|
|Web|Servlet, JSP | [Servlet, JSP via Jetty](%latestjavaurl%}/web-processing-unit-container.html)|
|Packaging and deployment|EAR , war|[jar]({%latestjavaurl%}/the-processing-unit-structure-and-configuration.html), [war]({%latestjavaurl%}/web-processing-unit-container.html) , EAR {% star %}|
|Contexts and Dependency Injection|JSR 299|Spring IOC|
|System Management|JMX|[JMX]({%latestjavaurl%}/snmp-connectivity-via-alert-logging-gateway.html) , [SNMP]({%latestjavaurl%}/snmp-connectivity-via-alert-logging-gateway.html), [Native Admin API]({%latestjavaurl%}/administration-and-monitoring-api.html)|
|Java Naming and Directory Service|JNDI|[Jini Lookup Service](./about-jini.html)|

-  {% star %} Available via [EasyBeans](http://www.easybeans.net/xwiki/bin/view/Main/WebHome), [openejb](http://openejb.apache.org), [embedded jboss](http://docs.jboss.org/ejb3/embedded/embedded.html) or [embedded-glassfish](http://embedded-glassfish.java.net).

## Messaging Concepts & Patterns

{: .table .table-bordered}
|Functionality|J2EE|XAP|
|:------------|:---|:--|
|Queue|JMS Queue|[Polling Container]({%latestjavaurl%}/polling-container.html)|
|Topic|JMS Topic|[Notify Container]({%latestjavaurl%}/notify-container.html)|
|Unit of Order|JMS UOO|[{%color green%}XAP Unit Of Work{%endcolor%}](/sbp/unit-of-work.html)|
|Queue Partitioning|JMS Service Activator Aggregator Strategy|[{%color green%}XAP Parallel Queue{%endcolor%}](/sbp/parallel-queue-pattern.html)|
|Distributed Priority Queue|JMS Quality of Service|[{%color green%}XAP Priority Based Queue{%endcolor%}](/sbp/priority-based-queue.html)|
|Compute Grid|MDB + Custom code|[{%color green%}XAP Master-Worker{%endcolor%}](/sbp/master-worker-pattern.html)|
