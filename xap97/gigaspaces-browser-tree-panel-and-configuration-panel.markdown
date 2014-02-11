---
layout: post
title:  GigaSpaces Browser Tree Panel and Configuration Panel
categories: XAP97
parent: using-space-browser-tab---gigaspaces-management-center.html
weight: 100
---

{% summary %}Using the Grid Tree and the Configuration Panel on the right. {% endsummary %}

# Grid Tree Panel

The left hand panel of the Space Browser is the **Grid Tree**. This panel allows you to view and manage all registered space containers, their spaces on the network and clusters.

{% indent %}
![IMG212.gif](/attachment_files/IMG212.gif)
{% endindent %}

The **Grid Tree** shows the following main types of nodes: Space Container ( ![cluster_node.gif](/attachment_files/cluster_node.gif)).

# Spaces Network View

Click the main node in the tree, labeled **Spaces**, to view all the spaces currently running in the network.

{% indent %}
![GMC_space_SpaceNetworkView_6.5_RC2.jpg](/attachment_files/GMC_space_SpaceNetworkView_6.5_RC2.jpg)
{% endindent %}

The table shows various information regarding each space. Each column represents a different type of information. You can select the columns you want to appear in the table by right-clicking one of the column names and clicking **Select Columns**:

{% indent %}
![space_network_view_selectColumns_6.1.jpg](/attachment_files/space_network_view_selectColumns_6.1.jpg)
{% endindent %}

In the Select Columns window, check the checkboxes of the columns you want to see, or **Select All** (automatically selects all checkboxes):

{% indent %}
![space_network_view_selectColumns_window_6.5.jpg](/attachment_files/space_network_view_selectColumns_window_6.5.jpg)
{% endindent %}

{% infosign %} The **Name** (space name) and **Space Container Name** are default options and cannot be unchecked.

The columns to choose from are as follows:

- **Objects Count** -- the number of objects in the space.

   {% exclamation %} The **Objects Count** column does not display the number of objects for persistent spaces running in LRU mode (this might result in very high CPU usage). To change this, see the [Menus and Buttons](./gigaspaces-browser-menus-and-buttons.html#Display Persistent LRU Space Metrics) section.

- **Object Count Delta** -- shows an ascending or descending arrow, if the number of objects in the space is currently growing or being reduced (when objects are either written to or taken from the space). For example, if you are currently taking objects from a certain space, during the take operation, an arrow pointing down appears in this column (see screenshot above).

   {% exclamation %} For this option to work, the **Objects Count** checkbox must also be selected.

- **Templates Count** -- the number of templates in the space.
- **Host Name** -- the name of the machine hosting the space container.
- **Jini Group** -- the Jini lookup group used when starting the space.
- **Locators** -- the Jini locators used when starting the space.
- **Schema name** -- the space's current schema.
- **Persistent** -- whether the space is persistent or not.
- **Clustered** -- whether the space participates in a cluster.
- **Primary** -- whether the space is primary (**Yes**) or a backup space (**No**).
- **Used Memory (MB)** -- the amount of used memory in this space, in MB.
This column is highlighted in orange if the space memory usage is more than the minimum (low) watermark percentage and lower than the write only block percentage (defined in the [memory usage tag](./memory-management-facilities.html)), for example:

{% indent %}
![GMC_space_SpaceNetworkView_UsedMoemory_Column_Orange_6.5_RC2.jpg](/attachment_files/GMC_space_SpaceNetworkView_UsedMoemory_Column_Orange_6.5_RC2.jpg)
{% endindent %}

This column is highlighted in red if the space memory exceeds the write only block percentage (defined in the [memory usage tag](./memory-management-facilities.html)), for example:

{% indent %}
![space_network_view_memoryUsage_red_6.5.jpg](/attachment_files/space_network_view_memoryUsage_red_6.5.jpg)
{% endindent %}

{% refer %}For more details on memory usage, refer to the [Memory Management](./memory-management-facilities.html) section.{% endrefer %}

- **Write**, **Update**, **Read**, **Take**, **Notify Sent**, **Notify Ack.**, **Notify Registration** -- shows the number of objects the operation has been performed on. For example, 60000 in the **Write** column means that 60000 objects have been written to this space.

You can right-click a row in the table to view options for a space. These are the same options available under each space node (see [Space Node](#spacenode) below). Clicking one of the options in the context menu switches to the clicked view, and selects the space in the tree on the left. This is an easy way to access a space or any its sub-nodes directly, without expanding the **Grid Tree**.

{% indent %}
![space_network_view_spaceNodeSelected_6.5.jpg](/attachment_files/space_network_view_spaceNodeSelected_6.5.jpg)
{% endindent %}

{% include /COM/jconsolejmapwarning.markdown %}

You can choose to refresh the Space Network view periodically. Select the desired refresh rate from the **Refresh Rate** drop-down menu. To stop automatically refreshing the Space Network View, click the **Stop** button. When auto-refresh is running, a green blinking dot is displayed on the right side of the screen.

# Space Container Node

Right-clicking a space container node ( ![container.gif](/attachment_files/container.gif)) invokes a context menu containing the following options:

{% indent %}
![grid_tree_containerNodeSelected_6.5.jpg](/attachment_files/grid_tree_containerNodeSelected_6.5.jpg)
{% endindent %}

- **Refresh** -- refreshes the tree panel display.
- **Runtime Configuration Report** -- displays the current configuration of the selected space container (see [Runtime Configuration Report](./space-container-configuration-general-tab---gigaspaces-browser.html#Runtime Configuration Report)).
- **Launch JConsole** -- launches a [JConsole](./space-jmx-management.html) for the selected space container.

When the space container node is selected, its configuration data is displayed in the configuration panel on the right side.

Selecting the space container node also makes available the three leftmost buttons on the button toolbar at the top of the GigaSpaces Browser screen. These allow you to create a space and perform several maintenance operations on the space container.

# Space Node

{% anchor spacenode %}
Space nodes ( ![spaceTreeIcon.gif](/attachment_files/spaceTreeIcon.gif)) represent a single space in the system.

**The space node has five possible views:**

- [Classes view](./data-types-view---gigaspaces-browser.html)
- [Query view](./query-view---gigaspaces-browser.html)
- [Statistics view](./statistics-view---gigaspaces-browser.html)
- [Benchmark view](./benchmark-view---gigaspaces-browser.html)
- [Transactions view](./transactions-view---gigaspaces-browser.html)
- [Connections view](./connections-view---gigaspaces-browser.html)

Right-clicking a space node invokes a context menu containing the following options:

- **Clean** -- cleans the space.
- **Ping** -- pings the space.

{% indent %}
![IMG214.gif](/attachment_files/IMG214.gif)
{% endindent %}

When a space node is selected, its configuration data is displayed in the **Service View** panel on the right side:

{% indent %}
![network_view_config.gif](/attachment_files/network_view_config.gif)
{% endindent %}

# Cluster Node

A cluster is a collection of spaces from one or more space containers. The cluster node ( ![cluster_node.gif](/attachment_files/cluster_node.gif)) in the **Grid Tree** represents a cluster of spaces.
{% refer %}For more details, refer to the [Cluster View](./cluster-view---gigaspaces-browser.html) section.{% endrefer %}

# Service View panel

The **Service View** panel takes up most of the Space Browser screen; it is located on the right of the **Grid Tree** panel. This panel shows configuration details for the node selected in the tree on the left, allowing you to edit some of them.
