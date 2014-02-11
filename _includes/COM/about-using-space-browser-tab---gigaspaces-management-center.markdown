{% compositionsetup %}

# Overview

The Space Browser tab allows you to view and configure two main components in GigaSpaces -- space and cluster.

The main **Spaces** node ![space_network_view_icon.gif](/attachment_files/space_network_view_icon.gif) displays the _Space Network view_ -- a table listing all spaces in the network, and different details regarding those spaces.

The **Spaces** node includes:

- Space container nodes ![container.gif](/attachment_files/container.gif) that hold spaces (![spaceTreeIcon.gif](/attachment_files/spaceTreeIcon.gif). Container nodes allow you to manage space containers -- shutting down the container, creating a space under it, and more.
- Space nodes ![spaceTreeIcon.gif](/attachment_files/spaceTreeIcon.gif) allow you to manage spaces -- starting or stopping, destroying, cleaning the space, and more. Each space node includes different views under it, that allow you to manage it further.

{% togglecloak id=1 %}See screenshot...{% endtogglecloak %}

{% gcloak 1 %}
{% panel bgColor=white|borderStyle=none %}
{% indent %}![GMC_space_6.0.jpg](/attachment_files/GMC_space_6.0.jpg){% endindent %}
{% endpanel %}
{% endgcloak %}

The main **Clusters** node ![cluster_node.gif](/attachment_files/cluster_node.gif) includes:
- Cluster nodes ![specific_cluster_icon.jpg](/attachment_files/specific_cluster_icon.jpg) that allow you to manage the cluster -- stop, start, restart, clean the cluster, and more.
- Cluster group nodes ![cluster_topology_icon.jpg](/attachment_files/cluster_topology_icon.jpg) hold the cluster members ![spaceTreeIcon.gif](/attachment_files/spaceTreeIcon.gif). Clicking a cluster member displays a graphic representation of the cluster, and tables showing details regarding replication, failover, load-balancing, and classes.

{% togglecloak id=2 %}See screenshot...{% endtogglecloak %}

{% gcloak 2 %}
{% panel bgColor=white|borderStyle=none %}
{% indent %}![GMC_space_clusterNodeSelected_6.0.jpg](/attachment_files/GMC_space_clusterNodeSelected_6.0.jpg){% endindent %}
{% endpanel %}
{% endgcloak %}

