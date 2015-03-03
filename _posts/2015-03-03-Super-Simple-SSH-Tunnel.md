---
layout: post
title: Super Simple SSH Tunnel
---

> Please Note: 
> This post is purely for interest's sake. I highly recommend you do not do this at your organisation as you may quickly find yourself on the wrong end of a workplace agreement violation.


### Overview

This guide shows you how to set up a quick and dirty SSH tunnel from your workstation to a server in a remote, hard-to-get-at network. It makes use of a gateway machine in AWS to maintain the tunnel connection and includes all the tricks required to get through proxies and firewalls. 


##### The Server Bits

Three separate machines are involved in setting up the tunnel in this guide:

* 1 local machine to SSH from
* 1 remote machine to SSH into
* 1 AWS EC2 instance to act as a gateway

This guide assumes that your remote machine and gateway are running _Ubuntu_ and your workstation is running _OS X_, however the configuration would not vary too much on other systems, and this guide could be adapted to support SSH client/server software running platforms including _Red Hat_ and even _Windows_.


##### The Tunneling Example

_The Goal: Establish a simple tunnel from a local workstation to a remote HTTP server._

The SSH tunnel in this example is made up of two persistent SSH connections - one from the local workstation side and one from the remote machine side. When established, the connections between the machines involved look like this:

{% include bordered.html url="/assets/diagrams/tunnel-diagram-2.png" description="Diagram of SSH tunnel diagram described in this guide." %}

Here we have port `5678` opened up on the local workstation via an `ssh -L` connection which forwards connections to port `1234` on the gateway. From the remote side, the `ssh -R` connection forwards connections on port `1234` on to the remote servier on port `8000`:

{% include bordered.html url="/assets/diagrams/curl-test-local-1.png" description="Output of `curl` command when run on workstation." %}

The command above acts in the same way as if the following was executed on the remote server:

{% include bordered.html url="/assets/diagrams/curl-test-remote-1.png" description="Equivalent `curl` output on remote server." %}

This guide will take you through all the steps necessary to recreate this example.


### Part 1: Build the Gateway

Since the gateway does very little work, besides forwarding packets from once port to another, we can get away with using the smallest EC2 instance available. In this case, I am using a `t2.micro` instance with Ubuntu 14.04. 


##### Step 1 - Launch New EC2 Instance

1. Navigate to your preferred Amazon region and click _Launch Instance_:
{% include thumb.html url="/assets/diagrams/aws-01.png" %}

2. Select _Ubuntu_ as the AMI:
{% include thumb.html url="/assets/diagrams/aws-02.png" %}

3. Ensure _t2.micro_ is selected and click _Next: Configure Instance Details_:
{% include thumb.html url="/assets/diagrams/aws-03.png" %}

4. Leave default instance values and click _Next: Add Storage_:
{% include thumb.html url="/assets/diagrams/aws-04.png" %}

5. Leave default storage values and click _Next: Tag Instance_:
{% include thumb.html url="/assets/diagrams/aws-05.png" %}

6. Enter name `tunnel-test-1` and click _Next: Configure Security Group_:
{% include thumb.html url="/assets/diagrams/aws-06.png" %}

7. Click _Add Rule_ and create new Custom TCP rule for port `443` and click _Review and Launch_:
{% include thumb.html url="/assets/diagrams/aws-07.png" %}

8. Review instance details and click _Launch_:
{% include thumb.html url="/assets/diagrams/aws-08.png" %}

9. Select _Create a new key pair_, enter `tunnel-key-1` as the Key pair name and click _Download Key Pair_:
{% include thumb.html url="/assets/diagrams/aws-09.png" %}

10. Save the _tunnel-key-1.pem_ file to a new folder on your workstation called `/tmp/tunnel`, then click _Launch Instance_:
{% include thumb.html url="/assets/diagrams/aws-10.png" %}

11. Once launched, navigate back to the EC2 Services dashboard and note the status and the IP address of the new `tunnel-test-1` instance:
{% include thumb.html url="/assets/diagrams/aws-11.png" %}


##### Step 2 - Configure SSH On EC2 Instance

With the new gateway service up and running on Amazon, the next step is to prepare it to receive SSH connections on port `443`.

1. Ensure the `tunnel-key-1.pem` key file, downloaded from Amazon to a new `/tmp/tunnel` folder on your workstation, has the correct permissions by running:

    ```bash
    chmod 600 /tmp/tunnel/tunnel-key-1.pem
    ```

2. Using the key file, log into gateway instance from your workstation using the following:

    ```bash
    export GATEWAY=54.66.197.58
    ssh ubuntu@${GATEWAY} -i /tmp/tunnel/tunnel-key-1.pem
    ```

    Where `GATEWAY` points to the IP address that was noted in Step 1. If successful, you will be presented with the command prompt of the new instance:
{% include thumb.html url="/assets/diagrams/ec2conf-1.png" %}

3. Switch to `root` by running `sudo su`, then open the sshd config file for editing using `vi /etc/ssh/sshd_config`:
{% include thumb.html url="/assets/diagrams/ec2conf-2.png" %}

4. Add an additional `Port 443` configuration line underneath the existing `Port 22` declaration and save the file:
{% include thumb.html url="/assets/diagrams/ec2conf-3.png" %}

5. Restart the `ssh` service by running `service ssh restart`:
{% include thumb.html url="/assets/diagrams/ec2conf-4.png" %}

6. To allow the `root` account to SSH directly into the server, edit the `/root/.ssh/authorized_keys` file and remove the comment at the beginning of the first line, so that the line starts with `ssh-rsa AAA...`:
{% include thumb.html url="/assets/diagrams/ec2conf-5.png" %}

    After editing, the contents of the `/root/.ssh/authorized_keys` file should look something like this:
{% include thumb.html url="/assets/diagrams/ec2conf-6.png" %}

7. Check that `root` account can no ssh into the gateway on port `443` by running:

    ```bash
    ssh -p 443 root@${GATEWAY} -i /tmp/tunnel/tunnel-key-1.pem
    ```

    A successful connection will display a command prompt for the `root` account:
{% include thumb.html url="/assets/diagrams/ec2conf-7.png" %}


##### Step 3 - Add Chatty Script to Gateway

This script is used by both the local and remote machines to maintain a persistent connection to the gateway. When executed, the script outputs a tiny bit of text at random intervals, making it appear to be an active, healthy connection to the surrounding infrastructure and reduces the risk that the connection will be terminated. I have found this method to be sufficient to keep the tunnel connection maintained for weeks on end.













TBC...