---
layout: post
title:  GigaSapces Management Center
categories: XAP97
parent: graphical-user-interface.html
weight: 100
---

{% compositionsetup %}{% summary section %}GigaSpaces Management Center is a GUI that allows you to view spaces, containers, and clusters and configure them, using the Space Browser tab. You can also deploy and manage services using the Deployments tab.{% endsummary %}

{% tip title=Using the GigaSpaces Management Center in production and large-scale environments %}

- It is highly recommended to run the GigaSpaces Management Center on the **same network subnet** as the Data-Grid and other GigaSpaces runtime components are running. Since the GigaSpaces Management Center communicates with the Data-Grid,GSCs, GSM, GSA and Lookup-Service continuously, it should have fast connectivity with these components. High latency connectivity will impact the responsiveness of the GigaSpaces Management Center and its initial bootstrap time. In production environments you should use remote desktop products such as [VNC](http://www.realvnc.com/products/free/4.1/index.html) or [No Machine](http://www.nomachine.com), run the GigaSpaces Management Center at the **same** network subnet as the Data-Grid and the other GigaSpaces runtime components and run the VNC or NX client side to access the remote machines desktop from the administrator machine desktop.
- With relatively large amount of GSCs , Services or Data-Grid partitions (over 20 units) it is recommended to increase the heap size of the GigaSpaces Management Center to 1G (-Xmx1g).
{% endtip %}

{% include /COM/about-gigaspaces-management-center.markdown %}

{%comment%}
{% include xap97/using-space-browser-tab---gigaspaces-management-center.markdown %}

{%endcomment%}

{%children%}
