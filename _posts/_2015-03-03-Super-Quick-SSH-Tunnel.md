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

### Tunneling Example

_The Goal: Establish a simple tunnel from a local workstation to a remote HTTP server._

The SSH tunnel in this example is made up of two persistent SSH connections - one from the local workstation side and one from the remote machine side. When established, the connections between the machines involved look like this:

<img src="/assets/diagrams/tunnel-diagram-2.png" />

Here we have port `5678` opened up on the local workstation via an `ssh -L` connection which forwards connections to port `1234` on the gateway. From the remote side, the `ssh -R` connection forwards connections on port `1234` on to the remote servier on port `8000`. 

<img src="/assets/diagrams/curl-test-local-1.png" />
<div class="diagram">Output of `curl` command run on workstation.</div>

<img src="/assets/diagrams/curl-test-remote-1.png" />
<div class="diagram">Equivalent `curl` output on remote server.</div>

{% include diagram.html url="/assets/diagrams/curl-test-remote-1.png" description="Equivalent `curl` output on remote server." %}




With this tunnel established, a connection to `localhost:5678` will foward all the way through to port `8000` on the remote server.