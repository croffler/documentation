---
type: post1.0
title:  Cluster Setup
categories: SPARK-XAP-010
weight: 1100
---


In this tutorial, you will learn how to install and run the InsightEdge on a cluster.


# Starting the whole cluster

Your cluster should consist of one master and a bunch of slaves:

* Master nodes usually have the Spark master and the Data Grid management running
* Slave nodes have Spark workers and Data Grid cluster members running on them

{{%warning%}}
Currently, only demo mode is available for Windows.
{{%/warning%}}

The `insightedge` scripts makes it easy to install and run/restart a remote cluster.
When you are running the following commands for the first time, append `--install` flag to install the InsightEdge on remote hosts.
After that, ommit the `--install` flag to start or restart the whole cluster.

Here is an example of the full automation script with the `--install` flag:

{{%tabs%}}
{{%tab Community%}}
```bash
export MASTER=10.0.0.1
export SLAVES=10.0.0.2,10.0.0.3,10.0.0.4
export IEPATH=/home/insightedge/insightedge

./sbin/insightedge.sh --install --mode remote-master --hosts $MASTER \
  --user insightedge --key ~/.shh/dev.pem \
  --path $IEPATH --master $MASTER

./sbin/insightedge.sh --install --mode remote-slave --hosts $SLAVES \
  --user insightedge --key ~/.shh/dev.pem \
  --path $IEPATH --master $MASTER --topology 3,1
```
{{%/tab%}}
{{%tab Premium%}}
```bash
export MASTER=10.0.0.1
export SLAVES=10.0.0.2,10.0.0.3,10.0.0.4
export IEPATH=/home/insightedge/insightedge

./sbin/insightedge.sh --mode undeploy \
  --master $MASTER --group dev-env

./sbin/insightedge.sh --install --mode remote-master --hosts $MASTER \
  --user insightedge --key ~/.shh/dev.pem \
  --path $IEPATH --master $MASTER

./sbin/insightedge.sh --install --mode remote-slave --hosts $SLAVES \
  --user insightedge --key ~/.shh/dev.pem \
  --path $IEPATH --master $MASTER

./sbin/insightedge.sh --mode deploy \
  --master $MASTER --group dev-env --topology 3,1
```
{{%/tab%}}
{{%/tabs%}}

After installation you can verify that Spark slaves are up and running on the Spark master web UI at `http://your-master-ip-here:8080`.

Let's now see the above example in detail.


# Running InsightEdge master

InsightEdge master starts Spark and Data Grid master on the node.

Master can be launched with `--mode master` or `--mode remote-master`. First mode will run/restart the Master locally, second one will connect to a remote host to run/restart the Master.

Here is the syntax and an example of running the master on the remote node:

```bash
# syntax
./sbin/insightedge.sh \
  --mode remote-master --hosts {node ip} --user {ssh user} --key {optional ssh access key} \
  --install --path {absolute path to install to} --master {master cluster ip}

# example:
#   connects to remote node
#   downloads and unpacks fresh InsightEdge distribution
#   runs Spark and DataGrid master
./sbin/insightedge.sh
  --mode remote-master --hosts 10.0.0.1 --user insightedge --key ~/.ssh/dev.pem \
  --install --path /home/insightedge/insightedge --master 10.0.0.1
```


# Running InsightEdge slave

InsightEdge slave starts Spark worker and Data Grid container on the node.

Slave can be launched with `--mode slave` or `--mode remote-slave`. First mode will run/restart the Slave locally, second one will connect to a remote host to run/restart the Slave.

Here is the syntax and an example of running the slave on the remote node:

{{%tabs%}}
{{%tab Community%}}
```bash
# syntax
./sbin/insightedge.sh \
  --mode remote-slave --hosts {node ips} --user {ssh user} --key {optional ssh access key} \
  --install --path {absolute path to install to} --master {master cluster ip} --topology {number of primaries, number of backups}

# example:
#   connects to remote nodes, one by one
#   downloads and unpacks fresh InsightEdge distribution
#   runs Spark workers and DataGrid containers
#   topology 3,1 starts 3 primary partitions with 1 backup partition for each primary
./sbin/insightedge.sh
  --mode remote-slave --hosts 10.0.0.2,10.0.0.3,10.0.0.4 --user insightedge --key ~/.ssh/dev.pem \
  --install --path /home/insightedge/insightedge --master 10.0.0.1 --topology 3,1
```
{{%/tab%}}
{{%tab Premium%}}
```bash
# syntax
./sbin/insightedge.sh \
  --mode remote-slave --hosts {node ips} --user {ssh user} --key {optional ssh access key} \
  --install --path {absolute path to install to} --master {master cluster ip}

# example:
#   connects to remote nodes, one by one
#   downloads and unpacks fresh InsightEdge distribution
#   runs one Spark worker and one DataGrid container per node
./sbin/insightedge.sh
  --mode remote-slave --hosts 10.0.0.2,10.0.0.3,10.0.0.4 --user insightedge --key ~/.ssh/dev.pem \
  --install --path /home/insightedge/insightedge --master 10.0.0.1
```
{{%/tab%}}
{{%/tabs%}}


# Deploying empty Data Grid space

{{%tabs%}}
{{%tab Community%}}
In Community edition space instances are being deployed during `remote-slave` mode.
{{%/tab%}}
{{%tab Premium%}}
```bash
# syntax
./sbin/insightedge.sh --mode deploy --master {master cluster ip}

# example:
#   topology 3,1 starts 3 primary partitions with 1 backup partition for each primary
./sbin/insightedge.sh --mode deploy --master 10.0.0.1 --topology 3,1
```
{{%/tab%}}
{{%/tabs%}}



# Configuration

You can specify a number of settings when using `insightedge.sh` script: e.g. Data Grid containers size, lookup locators and groups. To see the full list of settings, run the script without arguments:

```bash
./sbin/insightedge.sh
```


# Starting and stopping InsightEdge components

The `insightedge.sh` is just a wrapper script around more fine-grained scripts that would start and stop specific components.

You can start/stop Spark master and slave with these scripts:

```bash
./sbin/start-master.sh
./sbin/stop-master.sh
./sbin/start-slave.sh {master url}
./sbin/stop-slave.sh
```

Using these specific scripts comes at a cost of complexity when running Data Grid slaves in Community edition.
To run a component, you must specify which partition it corresponds to and if it's a primary or a backup partition.
The `--mode describe` simplifies allocating given topology on a given number of nodes.

The following scripts allow you to start/stop Data Grid master and slave:

{{%tabs%}}
{{%tab Community%}}
```bash
./sbin/start-datagrid-master.sh --master {master ip}
./sbin/stop-dagagrid-master.sh
./sbin/start-datagrid-slave.sh --master {master ip} --instances {slave role, see allocation below} --topology {topology}
./sbin/stop-datagrid-slave.sh

# allocate data grid instances for given topology and nodes count
./sbin/insightedge.sh --mode describe --topology {topology} --count {nodes count}

# examples of allocation:
./sbin/insightedge.sh --mode describe --topology 3,1 --count 2
# it gives the next output:
#   host_1:id=1;id=3;id=2,backup_id=1
#   host_2:id=2;id=1,backup_id=1;id=3,backup_id=1
# this means that node1 must run datagrid-slaves with allocation "id=1;id=3;id=2,backup_id=1"
# and node2 with "id=2;id=1,backup_id=1;id=3,backup_id=1"

# command for node1 with example allocation:
./sbin/start-datagrid-slave.sh --master 10.0.0.1 --instances id=1;id=3;id=2,backup_id=1 --topology 3,1
# command for node2 with example allocation:
./sbin/start-datagrid-slave.sh --master 10.0.0.1 --instances id=2;id=1,backup_id=1;id=3,backup_id=1 --topology 3,1
```
{{%/tab%}}
{{%tab Premium%}}
```bash
./sbin/start-datagrid-master.sh --master {master ip}
./sbin/stop-dagagrid-master.sh
./sbin/start-datagrid-slave.sh --master {master ip}
./sbin/stop-datagrid-slave.sh

# deploy/undeploy space
./sbin/deploy-datagrid.sh --master {master ip}
./sbin/undeploy-datagrid.sh --master {master ip}
```
{{%/tab%}}
{{%/tabs%}}
