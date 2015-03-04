---
layout: post
title: Super Simple SSH Tunnel - Overview
comments: true
---


{% include simple_ssh/toc.html %}

<a name="about"></a>
### About This Guide

This guide shows you how to set up a quick and dirty SSH tunnel from your workstation to a server in a remote, hard-to-get-at network. It makes use of a gateway machine in AWS to maintain the tunnel connection and includes all the tricks required to get through proxies and firewalls. 

{% include simple_ssh/disclaimer.html %}


<a name="sec1"></a>
### The Server Bits

Three separate machines are involved in setting up the tunnel in this guide:

* 1 local machine to SSH from
* 1 remote machine to SSH into
* 1 AWS EC2 instance to act as a gateway

This guide assumes that your remote machine and gateway are running _Ubuntu_ and your workstation is running _OS X_, however the configuration would not vary too much on other systems, and this guide could be adapted to support SSH client/server software running platforms including _Red Hat_ and even _Windows_.


<a name="sec2"></a>
### The Tunneling Example

_The Goal: Establish a simple tunnel from a local workstation to a remote HTTP server._

The SSH tunnel in this example is made up of two persistent SSH connections - one from the local workstation side and one from the remote machine side. When established, the connections between the machines involved look like this:

{% include bordered.html url="/assets/diagrams/simple_ssh/tunnel-diagram-2.png" description="Diagram of SSH tunnel diagram described in this guide." %}

Here we have port `5678` opened up on the local workstation via an `ssh -L` connection which forwards connections to port `1234` on the gateway. From the remote side, the `ssh -R` connection forwards connections on port `1234` on to the remote servier on port `8000`:

{% include bordered.html url="/assets/diagrams/simple_ssh/curl-test-local-1.png" description="Output of `curl` command when run on workstation." %}

The command above acts in the same way as if the following was executed on the remote server:

{% include bordered.html url="/assets/diagrams/simple_ssh/curl-test-remote-1.png" description="Equivalent `curl` output on remote server." %}

This guide will take you through all the steps necessary to recreate this example.


<a name="next"></a>
### Next Step

Please continue on to [Part 1 - Building the Gateway]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Part-1 %}) for the next part of this guide.

