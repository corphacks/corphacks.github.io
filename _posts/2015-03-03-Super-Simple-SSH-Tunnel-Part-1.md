---
layout: post
title: Super Simple SSH Tunnel - Part 1
comments: true
---


### Building the Gateway

  This post describes the first of three parts of my [Super Simple SSH Tunnel]({% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Overview %}) guide. The goal of this post is to get new server up and running in AWS to act as a gateway for SSH tunneling.


<a name="shortver"></a>
##### Step 1 - Launch New EC2 Instance

__Short Version:__

If you already know your way around AWS, then all you need to do for this step is:

* Create a new `t2.micro` instance running _Ubuntu_
* Configure the Security Group to include a new Custom Rule to allow incoming traffic on port `443`
* Generate a new SSH key pair and save the private key to a folder called `/tmp/tunnel` on your workstation 

Once the new instance is launched, the key file downloaded and the public IP address is noted, continue on to Step 2.

<a name="longver"></a>
__Long Version:__

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


### Moving On

Please move on to the next step of this guide: [Part 2 - The Remote Server](% post_url 2015-03-03-Super-Simple-SSH-Tunnel-Part-2 %).


{% include simple_ssh/toc.html %}
