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

As mentioned in the [Overview]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Overview %}#sec1) section of this guide, this assumes that the local workstation runs _Mac OS X_. The details here, however, will work across a number of different platforms, including _Linux_ and _Windows_ and any platform that supports `openssh` (such as (Cygwin)[https://www.cygwin.com/] and (msysGit)[https://msysgit.github.io/]).


<a name="step1"></a>
### Step 1 - Local SSH Tunnel Config

1. Ensure that the AWS gateway key file, created in [Part 1]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Part-1 %}) of this guide, still sits in the `/tmp/tunnel` folder of your workstation. 

2. Create a new script called `/tmp/tunnel/local-side-tunnel.sh` with the following contents:

    ```bash
    #!/bin/bash

    set -e

    TUNNEL_GATEWAY="54.66.197.58"
    TUNNEL_KEY="/tmp/tunnel/tunnel-key-1.pem"
    CONNECT_STR="simplehttp_home"
    LOCAL_PORT=5678
    GATEWAY_PORT=1234

    ssh -p 443 -L $LOCAL_PORT:localhost:$GATEWAY_PORT -i $TUNNEL_KEY -l root $TUNNEL_GATEWAY ./chatty.sh $CONNECT_STR
    ```

3. Run the script using the following command:

    ```bash
    sh /tmp/tunnel/local-side-tunnel.sh
    ```

    If successful, the `chatty.sh` script on the gateway will begin generating output which will look something like this:

    {% include bordered.html url="/assets/diagrams/simple_ssh/localconf-1.png" %}

<a name="step2"></a>
### Step 2 - The Final Test

1. Ensure that the `simple-http.sh` script from [Part 2, Step 2]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Part-2%}#step2) is still running and accepting requests on the remote server.

2. Ensure that the `remote-side-tunnel.sh` script from [Part 2, Step 3]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Part-2 %}#step3) is still running on the remote server and generating output from the `chatty.sh` script.

3. Ensure that the `local-side-tunnel.sh` script from [Step 1](#step1) above is still running and generating output from the `chatty.sh` script.

4. In a new terminal on the local workstation, test the tunnel by running the following:

    ```bash
    curl http://localhost:5678/
    ```

    If all goes well, the request to port `5678` will be forwarded to the gateway and then forwarded on to the remote server on port `8000` to be served by the `simple-http.sh` script, sending the response back through the tunnel to port `5678` on the local machine:

    {% include bordered.html url="/assets/diagrams/simple_ssh/curl-test-local-1.png" %}
    

<a name="sec2"></a>
### Conclusion

This guide demonstrated a very simple tunnel example, however this method could be modified to support the tunneling of any service, or multiple services, from the remote server back through to your local workstation. And when used in combination with other traffic routing applications, such as `rinetd`, the options for tunneling services from within the remote network to your local workstation are endless.

