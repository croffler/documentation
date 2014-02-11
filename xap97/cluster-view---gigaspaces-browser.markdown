---
layout: post
title:  Cluster View - GigaSpaces Browser
categories: XAP97
parent: working-with-clusters---gigaspaces-browser.html
weight: 100
---

{% summary %}Using Cluster View areas: Cluster Tree, visual display, legend, and information panel.{% endsummary %}

# Overview

Cluster View presents a graphic representation of the spaces in a cluster, the groups they comprise (replication, failover and load-balancing groups), and the relationships among them.
Cluster View complements the visualization provided by the Container Tree panel, because it uses the cluster configuration file, as well as the GigaSpaces Server, as a reference. As a result, you can visualize spaces whether they are online or offline, without loading their containers. While the Container Tree panel is a good way to see which spaces are currently running, Cluster View gives you a larger picture of the space architecture.

Another important advantage of Cluster View over the Container Tree panel is that it shows groups as an intermediate level between spaces and clusters. This level has always been a part of cluster configuration files, but it is now easier to visualize.

An important distinction between Cluster View and the Container Tree is that the Cluster View is exclusively a monitoring tool. It does not allow you to perform any operations on clusters, groups or spaces, or to modify cluster or space configuration.

# Cluster View Areas

The Cluster View is divided into four main areas:

- **Cluster tree** -- at the top of the tree is the cluster node (![spaceTreeIcon.gif](/attachment_files/spaceTreeIcon.gif)), each representing a space listed in the cluster configuration file.

{% oksign %} Each cluster node (![GMC_space_OperationsClusterNode_icon_6.5.jpg](/attachment_files/GMC_space_OperationsClusterNode_icon_6.5.jpg)), which allows you to view all cluster information in one node (for more details, see [below](#Viewing Information for Entire Cluster)).

- **Visual display** -- this area changes according to your selection in the tree. When you select the cluster node, the visual display shows the groups in the cluster.

{% indent %}
![GMC_space_cluster_MainClusterNodeSelected_6.5.jpg](/attachment_files/GMC_space_cluster_MainClusterNodeSelected_6.5.jpg)
{% endindent %}

When you select a group node, the display shows the spaces in the node. When you select a space, either by double-clicking it here or by clicking its node in the tree, the display focuses on that space and shows its connections to other spaces (in a replication group).

- **Legend** -- shows the meaning of the colors used in the visual display. There is a different legend for full cluster view and for spaces-in-group view.
- **Information Panel** -- when you select the cluster node in the tree, basic details about all the cluster's members are displayed here. When you select a space, by clicking its node in the tree or its representation in the visual display, this area divides into a number of tabs that provide a detailed description of the space's configuration settings, and its replication connections (in a replication group). All the information displayed in this panel is read-only.

{% indent %}
![GMC_space_cluster_SpecificClusterNodeSelected_6.5.jpg](/attachment_files/GMC_space_cluster_SpecificClusterNodeSelected_6.5.jpg)
{% endindent %}

{% exclamation %} The view above does not display the number of objects for persistent spaces in LRU mode, since this might result in very high CPU usage. To change this, see the [Menus and Buttons](./gigaspaces-browser-menus-and-buttons.html#Display Persistent LRU Space Metrics) section.

## Viewing Information for Entire Cluster

The **Operations** cluster node (![GMC_space_OperationsClusterNode_icon_6.5.jpg](/attachment_files/GMC_space_OperationsClusterNode_icon_6.5.jpg)) allows you to view all classes, data, statistics, transactions, and connections for the entire cluster under a single node.

{% indent %}
![GMC_space_cluster_OperationsNodeTree_6.5.jpg](/attachment_files/GMC_space_cluster_OperationsNodeTree_6.5.jpg)
{% endindent %}

The views under the **Operations** node have the same functionality as the views under the regular space/cluster nodes:

- **Data Types view** -- allows you to view all classes in the cluster and to inspect class objects. For more details, refer to the [Classes View](./data-types-view---gigaspaces-browser.html) section.
- **Transactions view** -- displays all transactions in the cluster. For more details, refer to the [Transactions View](./transactions-view---gigaspaces-browser.html) section.
- **Query view** -- allows you to query space classes and to inspect class objects. For more details, refer to the [Query View](./query-view---gigaspaces-browser.html) section.
- **Statistics view** -- displays statistics for operations performed in the cluster. For more details, refer to the [Statistics View](./statistics-view---gigaspaces-browser.html) section.
- **Connections view** -- displays connections to the cluster (includes additional columns: **Cluster Member Name**, **Server IP Address**, **Server Port**). For more details, refer to the [Connections View](./connections-view---gigaspaces-browser.html) section.

# More in this Section

- [Top-level view: groups and cluster members](./visualizing-cluster-groups-and-members---gigaspaces-browser.html)
- [Viewing space interrelations](./viewing-space-interrelations-in-cluster---gigaspaces-browser.html)
- [Viewing space settings](./viewing-cluster-policy-settings-for-space---gigaspaces-browser.html)
- [Customizing the cluster view display](./customizing-cluster-view---gigaspaces-browser.html)
