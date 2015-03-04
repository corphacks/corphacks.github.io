---
layout: post
title: Super Simple SSH Tunnel - Part 3
comments: true
---


### The Local Workstation

This is the final part of a 3-part guide to creating a simple SSH tunnel connection. This section covers the SSH configuration required on a local workstation in order to connect to a remote service via a gateway server on AWS.


{% include simple_ssh/disclaimer.html %}

<a name="sec1"></a>
### Configuring Local SSH

As mentioned in the [Overview]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Overview %}#sec1) section of this guide, this assumes that the local workstation runs _Mac OS X_. The details here, however, will work across a number of different platforms, including _Linux_ and _Windows_ and any platform that supports `openssh` (such as (Cygwin)[https://www.cygwin.com/]).


<a name="step1"></a>
##### Step 1 - Local SSH Tunnel



1. 


{% include simple_ssh/toc.html %}