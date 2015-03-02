---
layout: post
title: Super Quick SSH Tunnel
---

> Please Note: 
> This post is purely for interest's sake. I highly recommend you do not do this at your organisation as you may quickly find yourself on the wrong end of a workplace agreement violation.

### Overview

This guide shows you how to set up a quick and dirty SSH tunnel from your workstation to a server in a remote, hard-to-get-at network (for example, your work network). It makes use of a gateway machine in AWS to maintain the tunnel connection and includes all the tricks required to get through proxies and firewalls. 

### The Bits

* 1 AWS EC2 micro instance running Ubuntu
* 1 remote machine to SSH into
* 1 local machine to SSH from

### Tunneling Overview

The SSH tunnel in this example is made up of two persistent SSH connections, one from the local workstation side and one from the remote machine side. When established, the connections between the machines involved look like this:

<img src="/assets/diagrams/tunnel-diagram-2.png" />

Here we have port 5678 opened up on the local workstation which forwards connections to port 1234 on the gateway which forwards that on to port 8000 on the remote server. With this tunnel established, a connection to localhost:5678 will act as though a connection was made to the remote server on port 8000:

<img src="/assets/diagrams/curl-test-1.png" />

TBC...