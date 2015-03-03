---
layout: post
title: Super Simple SSH Tunnel - Part 2
comments: true
---


### Overview

This section describes the steps required to establish SSH connections to the AWS gateway server from a remote server located behind a corporate proxy or firewall.

{% include simple_ssh/disclaimer.html %}


<a name="sec1"></a>
## Part 2: The Remote Server

This guide focuses on a scenario that is common to corporate work environments, where the only way out of the network is via the corporate HTTP proxy. The connection through the proxy to the gateway is made using a program called `proxytunnel`. This section describes the steps required to install and configure this program for this purpose.


<a name="step1"></a>
##### Step 1 - Installing `proxytunnel` Program

As mentioned earlier in this guide, this part assumes the remote server is running _Ubuntu_, and therefore the `proxytunnel` application can be installed using the `apt` package manager, using the steps below.

> Please Note:
> In this scenario, it is likely that the `apt` application will itself require some way of connecting through the corporate proxy. Please see the post [Apt and the Corporate Proxy]({% post_url 2015-03-03-Apt-and-the-Corporate-Proxy %}) for details on how to achieve this.


<p>&nbsp;</p>
<p>&nbsp;</p>
<p>&nbsp;</p>
_... TBC..._

{% include simple_ssh/toc.html %}