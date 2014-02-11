
{% warning %}
Starting [JConsole](http://java.sun.com/developer/technicalArticles/J2SE/monitoring/) from the GS-UI or using JConsole with the JTop plug-in, may impact the JVM garbage collection behavior of the **monitored JVM**. See more details [here](http://stackoverflow.com/questions/3873635/java-concurrentmarksweep-garbage-collector-not-removing-all-garbage). To disable the JTop Tab when starting JConsole please rename the `JAVA_HOME\demo\management\JTop\JTop.jar`.
{% endwarning %} 

