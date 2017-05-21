---
type: post0.3
title:  Cluster Setup
categories: SPARK-XAP-003
weight: 1100
---






In this tutorial, you will learn how to install and run the InsightEdge on a cluster.




# Installation and first run on cluster

Your cluster should consist of one master and a bunch of slaves or workers. The master can also act as a slave, but it is recommended to avoid such setup.

* Master nodes usually have the Spark master and the Data Grid management running
* Slave nodes have Spark workers and Data Grid cluster members running on them

Here are three simple steps to install and run InsightEdge on your cluster:

# Install and run InsightEdge on master node

```bash
./sbin/insightedge.sh \
  --mode remote-master --hosts {node ip} --user {ssh user} --key {optional ssh access key} \
  --install --path {absolute path to install to} --master {master cluster ip}
```
Example:

```bash
./sbin/insightedge.sh
  --mode remote-master --hosts 10.0.0.1 --user insightedge --key ~/.ssh/dev.pem \
  --install --path /home/insightedge/insightedge --master 10.0.0.1
```
This command will connect to the master node, download and unpack fresh InsightEdge distribution and run the node as master.

# Install and run InsighEdge on slave nodes

Just use `remote-slave` mode and run the same command as above. To specify multiple slave nodes, provide a comma-separated list of ips or hostnames with `--hosts` argument, e.g. `--hosts 10.0.0.2,10.0.0.3,10.0.0.4`.

# Deploy empty Data Grid space

```bash
./sbin/insightedge.sh --mode deploy --master {master cluster ip}
```
Example:

```bash
./sbin/insightedge.sh --mode deploy --master 10.0.0.1
```

After installation you can verify that Spark slaves are up and running on the Spark master web UI at `http://your-master-ip-here:8080`.


# Configuration

You can specify a number of settings when using `insightedge.sh` script: e.g. Data Grid containers size, lookup locators and groups. To see the full list of settings by just running the script without arguments:

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

The following scripts allow you to start/stop Data Grid master and slave:

```bash
./sbin/start-datagrid-master.sh --master {master ip}
./sbin/stop-master.sh
./sbin/start-slave.sh --master {master ip}
./sbin/stop-slave.sh
```

Undeploy the Data Grid Space:

```bash
./sbin/deploy-datagrid.sh --master {master ip}
./sbin/undeploy-datagrid.sh --master {master ip}
```


# Automating cluster

After installation you can restart InsightEdge on the whole cluster. Here is an examples of such script:

```bash
export MASTER=10.0.0.1
export SLAVES=10.0.0.2,10.0.0.3,10.0.0.4
export PATH=/home/insightedge/insightedge

./sbin/insightedge.sh --mode undeploy \
  --master $MASTER --group dev-env

./sbin/insightedge.sh --mode remote-master --hosts $MASTER \
  --user insightedge --key ~/.shh/dev.pem \
  --path $PATH --master $MASTER

./sbin/insightedge.sh --mode remote-slave --hosts $SLAVES \
  --user insightedge --key ~/.shh/dev.pem \
  --path $PATH --master $MASTER

./sbin/insightedge.sh --mode deploy \
  --master $MASTER --group dev-env
```

{{%note%}}
Order of commands is important:

1. slaves won't be properly reloaded without the master running

2. slaves restart without the Space un-deploying will cause automatic Space recovery
{{%/note%}}

