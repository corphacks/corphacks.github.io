---
layout: post
title: Simple SSH Tunnel Guide - Part 2
comments: true
---


### The Remote Server

This section describes the steps required to establish SSH connections to the AWS gateway from a remote server. It focuses, in particular, on the scenario that is common to corporate work environments, where the only way to access the Internet is via the corporate HTTP proxy. To get to the gateway from the remote server, a program called `proxytunnel` is used. Installing and configuring `proxytunnel` is detailed below.


{% include simple_ssh/disclaimer.html %}


### Installation and Configuration

As mentioned in the [Overview]({% post_url 2015-03-03-Simple-SSH-Tunnel-Guide %}) section of this guide, this assumes that the remote server runs _Ubuntu_, and therefore makes use of the `apt` program to install `proxytunnel`. However, the details below can also be applied to other Linux platforms, such as _CentOS_ and _RedHat_, by replacing `apt` with `yum`. 


<a name="step1"></a>

### Step 1 - Installing and Configuring `proxytunnel` Program

1. Install `proxytunnel` via `apt` by running:

    ```bash
    sudo apt-get update && sudo apt-get install -y proxytunnel
    ```

    > Please Note:
    > In this scenario, it is likely that the `apt` application will itself require some way of connecting through the corporate proxy. Please see the post [Apt and the Corporate Proxy]({% post_url 2015-03-03-Apt-and-the-Corporate-Proxy %}) for details on how to achieve this.

2. Create new `/tmp/tunnel/tunnel-ssh.conf` file with the following contents:

    ```bash
    StrictHostKeyChecking no
    ProxyCommand proxytunnel --proxy=10.11.12.13:8080 --dest=54.66.197.58:443
    ```

    This configuration file will be used for new SSH connections to the AWS gateway server in [Step 3](#step3). Please ensure the correct proxy IP, proxy port and AWS gateway IP values are used for your environment.

    > For details on the different configration `proxytunnel` configuration options, including the `--ntlm` flag for using NTLM based authentication, and the `--proxyauth` parameter for specifying your proxy login credentials, please read through the `README` documentation at the [`proxytunnel` GitHub project page](https://github.com/proxytunnel/proxytunnel).


<a name="step2"></a>

### Step 2 - Setting Up Simple HTTP Test Server

A simple HTTP server, in the form of a python `SimpleHTTPServer` process, will be used to test the complete end-to-end tunnel connection. In this case, the python process will run on port `8000` on the remote server, and accessed on from the local workstation using the tunnel connection. 

1. Create new `/tmp/tunnel/simple-http.sh` script with the following contents:

    ```bash
    #!/bin/bash

    python -m SimpleHTTPServer
    ```

    Or, if python is not available on your remote server, the following script will also serve for testing purposes:

    ```bash
    #!/bin/bash
    
    while true
    do
      nc -l 127.0.0.1 8000 < index.html
    done
    ```

2. Create a simple `/tmp/tunnel/index.html` file to serve with the following contents:

    ```html
    <h1>It worked!</h1>
    ```

3. Run the `/tmp/tunnel/simple-http.sh` script using:

    ```bash
    cd /tmp/tunnel && simple-http.sh
    ```

    > Please note: the `simple-http.sh` process needs to remain running for the remainder of this guide.


4. In a separate terminal session on the remote server, test that the simple HTTP service works by executing:

    ```bash
    curl http://localhost:8000/
    ```

    The output should look something like this:

    {% include bordered.html url="/assets/diagrams/simple_ssh/curl-test-remote-1.png" %}
    

<a name="step3"></a>

### Step 3 - Establishing the Work-Side Tunnel Connection

With the test HTTP service running, a new SSH tunnel connection can now be established to direct traffic on the gateway to the remote service.

1. On the remote server, create a new file called `/tmp/tunnel/remote-side-tunnel.sh` with the following contents:

    ```bash
    #!/bin/bash

    set -e

    TUNNEL_GATEWAY="54.66.197.58"
    TUNNEL_CONF="/tmp/tunnel/tunnel-ssh.conf"
    TUNNEL_KEY="/tmp/tunnel/tunnel-key-1.pem"
    CONNECT_STR="simplehttp_work"
    GATEWAY_PORT=1234
    WORK_PORT=8000

    ssh -n -R $GATEWAY_PORT:localhost:$WORK_PORT -F $TUNNEL_CONF -i $TUNNEL_KEY -l root $TUNNEL_GATEWAY ./chatty.sh $CONNECT_STR 
    ```

    Please ensure the `TUNNEL_GATEWAY` value points to the IP address that was assigned to your AWS gateway in [Part 1]({% post_url 2015-03-03-Simple-SSH-Tunnel-Guide-Part-1 %}) of this guide.

2. Copy the AWS gateway key file to remote server to the path:

    ```bash
    /tmp/tunnel/tunnel-key-1.pem
    ```

3. Make sure the key file has the correct permissions by running:

    ```bash
    chmod 600 /tmp/tunnel/tunnel-key-1.pem
    ```

4. Run the new tunnel script using:

    ```bash
    sh /tmp/tunnel/remote-side-tunnel.sh
    ```

    If the connection is successful, the `chatty.sh` script on the gateway server will begin generating output which will look something like this:

    {% include bordered.html url="/assets/diagrams/simple_ssh/remoteconf-1.png" %}


<a name="next"></a>

### Next Step

Please continue on to [Part 3 - The Local Workstation]({% post_url 2015-03-03-Simple-SSH-Tunnel-Guide-Part-3 %}) for the next part of this guide.


{% include simple_ssh/toc.html %}
