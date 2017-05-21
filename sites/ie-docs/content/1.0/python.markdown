---
type: post1.0
title:  Python
categories: SPARK-XAP-010
weight: 650
---


InsightEdge has Python API available via PySpark. The functionality is limited to DataFrame API.


# Interactive Use

There are two options to analyze data interactively in Python: 

- [Zeppelin](./notebook.html)<br>
- command line shell.

# Zeppelin notebook

To develop notebooks in Python just use `%pyspark` interpreter in the Zeppelin. You can find the `InsightEdge python example` notebook as a reference example.

# Command line shell

To start the command line shell, run the `./bin/insightedge-pyspark` script in the InsightEdge directory.

For example, start InsightEdge in the demo mode:

{{%tabs%}}
{{%tab Linux%}}
```bash
./sbin/insightedge.sh --mode demo
```
{{%/tab%}}

{{%tab Windows%}}
```bash
sbin\insightedge.cmd --mode demo
```
{{%/tab%}}
{{%/tabs%}}

Then start the command line shell:

{{%tabs%}}
{{%tab Linux%}}
```bash
./bin/insightedge-pyspark --master spark://127.0.0.1:7077
```
{{%/tab%}}

{{%tab Windows%}}
```bash
bin\insightedge-pyspark --master spark://127.0.0.1:7077
```
{{%/tab%}}
{{%/tabs%}}

# Saving and loading DataFrames in Python

To operate on InsighEdge DataFrames, use the regular PySpark DataFrame API with the `org.apache.spark.sql.insightedge` format and specify Data Grid `collection` or `class` options. For example,

{{%tabs%}}
{{%tab "Python"%}}
```python
# load SF salaries dataset from file
jsonFilePath = os.path.join(os.environ["INSIGHTEDGE_HOME"], "data/sf_salaries_sample.json")
jsonDf = sqlContext.read.json(jsonFilePath)

# save DataFrame to the grid
jsonDf.write.format("org.apache.spark.sql.insightedge").mode("overwrite").save("salaries")

# load DataFrame from the grid
gridDf = sqlContext.read.format("org.apache.spark.sql.insightedge").option("collection", "salaries").load()
gridDf.show()
```
{{%/tab%}}
{{%/tabs%}}

You can also load a DataFrame backed by a DataGrid Scala class with the `class` options, e.g.:

{{%tabs%}}
{{%tab "Python"%}}
```python
df = sqlContext.read.format("org.apache.spark.sql.insightedge").option("class", "com.yourcompany.Data").load()
```
{{%/tab%}}
{{%/tabs%}}

# Self-Contained Applications

To develop the self-contained submittable application, just use the regular PySpark and configure InsightEdge settings in `SparkConf`:

{{%tabs%}}
{{%tab "Python"%}}
```python
from pyspark import SparkConf, SparkContext
from pyspark.sql import SQLContext

conf = SparkConf()
conf.setAppName("InsightEdge Python Example")
conf.set("spark.insightedge.space.name", "insightedge-space")
conf.set("spark.insightedge.space.lookup.group", "insightedge")
conf.set("spark.insightedge.space.lookup.locator", "127.0.0.1:4174")

sc = SparkContext(conf=conf)
sqlContext = SQLContext(sc)

...
```
{{%/tab%}}
{{%/tabs%}}

The complete source code is available at `./quickstart/python/sf_salaries.py`.

The application can be submitted with `insightedge-submit` script, e.g.

{{%tabs%}}
{{%tab Linux%}}
```bash
./bin/insightedge-submit ./quickstart/python/sf_salaries.py
```
{{%/tab%}}

{{%tab Windows%}}
```bash
bin\insightedge-submit quickstart\python\sf_salaries.py
```
{{%/tab%}}
{{%/tabs%}}
