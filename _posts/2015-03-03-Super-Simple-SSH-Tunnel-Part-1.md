---
layout: post
title: Super Simple SSH Tunnel - Part 1
comments: true
---


### Building the Gateway

  This post describes the first of three parts of my [Super Simple SSH Tunnel]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Overview %}) guide. The goal of this post is to get new server up and running in AWS to act as a gateway for SSH tunneling.


<a name="step1"></a>
### Step 1 - Launch New EC2 Instance

<a name="shortver"></a>
__Short Version__

If you already know your way around AWS, then all you need to do for this step is the following:

* Create a new `t2.micro` instance running _Ubuntu_
* Configure the Security Group to include a new Custom Rule to allow incoming traffic on port `443`
* Generate a new SSH key pair and save the private key to a folder called `/tmp/tunnel` on your workstation 

Once the new instance is launched, the key file downloaded and the public IP address is noted, continue on to Step 2.


<a name="longver"></a>
__Long Version__

Please skip to Step 2 if you are already familiar with creating new EC2 instances on 

1. Navigate to your preferred Amazon region and click _Launch Instance_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-01.png" %}

2. Select _Ubuntu_ as the AMI:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-02.png" %}

3. Ensure _t2.micro_ is selected and click _Next: Configure Instance Details_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-03.png" %}

4. Leave default instance values and click _Next: Add Storage_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-04.png" %}

5. Leave default storage values and click _Next: Tag Instance_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-05.png" %}

6. Enter name `tunnel-test-1` and click _Next: Configure Security Group_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-06.png" %}

7. Click _Add Rule_ and create new Custom TCP rule for port `443` and click _Review and Launch_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-07.png" %}

8. Review instance details and click _Launch_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-08.png" %}

9. Select _Create a new key pair_, enter `tunnel-key-1` as the Key pair name and click _Download Key Pair_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-09.png" %}

10. Save the _tunnel-key-1.pem_ file to a new folder on your workstation called `/tmp/tunnel`, then click _Launch Instance_:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-10.png" %}

11. Once launched, navigate back to the EC2 Services dashboard and note the status and the IP address of the new `tunnel-test-1` instance:
{% include thumb.html url="/assets/diagrams/simple_ssh/aws-11.png" %}


<a name="step2"></a>
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
{% include thumb.html url="/assets/diagrams/simple_ssh/ec2conf-1.png" %}

3. Switch to `root` by running `sudo su`, then open the sshd config file for editing using `vi` or similar:

    ```bash
    vi /etc/ssh/sshd_config
    ```

4. Add an additional `Port 443` configuration directive underneath the existing `Port 22` declaration and save the file:
{% include thumb.html url="/assets/diagrams/simple_ssh/ec2conf-3.png" %}

5. Restart the `ssh` service by running `service ssh restart`:
{% include thumb.html url="/assets/diagrams/simple_ssh/ec2conf-4.png" %}

6. To allow the `root` account to SSH directly into the server, edit the `/root/.ssh/authorized_keys` file and remove the comment at the beginning of the first line, so that the line starts with `ssh-rsa AAA...`:
{% include bordered.html url="/assets/diagrams/simple_ssh/ec2conf-5.png" %}

    After editing, the contents of the `/root/.ssh/authorized_keys` file should look something like this:
{% include bordered.html url="/assets/diagrams/simple_ssh/ec2conf-6.png" %}

7. Check that `root` account can now ssh into the gateway on port `443` by running:

    ```bash
    ssh -p 443 root@${GATEWAY} -i /tmp/tunnel/tunnel-key-1.pem
    ```

    A successful connection will display a command prompt for the `root` account:
{% include thumb.html url="/assets/diagrams/simple_ssh/ec2conf-7.png" %}


<a name="step3"></a>
##### Step 3 - Add Chatty Script to Gateway

This script is used by both the local and remote machines to maintain persistent connections to the gateway. When executed, the script outputs a tiny bit of text at random intervals, making it appear to be an active, healthy connection to the surrounding infrastructure, which helps reduce the risk that the connection will be terminated. I have found this method to be sufficient to keep the tunnel connection maintained for weeks on end.

Create this script as follows:

1. Log in to the gateway server as `root`, and create a new file called `/root/chatty.sh` with the following contents:

    ```bash
    #!/bin/bash

    set -e
    
    WHOISIT=not_sure
    
    if [ $# == 1 ]; then
      WHOISIT=$1
    fi
    
    while true; do
      R=$(( ( RANDOM % 30 )  + 11 ))
      printf "%14s : $R s\n" $WHOISIT
      sleep $R
    done
    ```

2. Ensure the script is executable by running:

    ```bash
    chmod +x /root/chatty.sh
    ```

3. Test that the script runs by executing 

    ```bash
    /root/chatty.sh testing
    ```

    The output should look something like this:

    {% include bordered.html url="/assets/diagrams/simple_ssh/chatty-1.png" %}

    Kill the process by hitting `CTRL-C`.

    The gateway server is now ready to persist SSH connections. 


<a name="next"></a>
### Next Step

Please continue on to [Part 2 - The Remote Server]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Part-2 %}) for the next part of this guide.


{% include simple_ssh/toc.html %}
