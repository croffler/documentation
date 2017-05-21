---
type: post0.3
title:  Zeppelin Notebook
categories: SPARK-XAP-003
weight: 1200
---





This section describes how to use the interactive Web Notebook.


# Starting Web Notebook

There are several options how you can start the Web Notebook:

* in a `demo` mode, Web Notebook is started automatically at `http://127.0.0.1:8090`. Refer to a [Quick Start](./quick_start.html) for `demo` mode details.
* when running a [remote cluster](./cluster_setup.html), Web Notebook is started on a master host on port `8090`

You can also start and stop Web Notebook any time manually with:
```bash
./sbin/start-zeppelin.sh
./sbin/stop-zeppelin.sh
```

# Web Notebook configuration

Any InsightEdge specific settings can be configured on *Interpreter* tab -> Spark Interpreter. The important settings include details on connecting Spark with the Data Grid:

* `gigaspaces.group`
* `gigaspaces.locator`
* `gigaspaces.spaceName`

These properties are transparently translated into `GigaSpaceConfig` to establish a connection between Spark and the Data Grid.

{{%refer%}}
Please refer to [Connecting to Data Grid](./connecting.html) for more details on the connection properties.
{{%/refer%}}

# Using Web Notebook

The Web Notebook comes with example notes, so we recommend to start exploring them and use them as a template for your own notes. There are several things you should take into account.

The current version of InsightEdge doesn't support declaring the Data Grid model in a notebook, you have to load data model as a jar dependency.

Example:

```
%dep
z.load("./quick-start/insightedge-examples.jar")
```

You have to load your dependencies before you start using the `SparkContext` (`sc`). If you want to load another jar which already started `SparkContext`, you have to reload the Spark interpreter.
