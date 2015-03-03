---
layout: post
title: Apt and the Corporate Proxy
comments: true
---

### Overview

This guide shows two quick methods of getting the _Aptitude_ program on _Debian_ and _Ubuntu_-based systems to successfully connect to remote package repositories from behind a corporate proxy. A proxy host IP address of `10.11.12.13` and port value of `8080` are used below for example purposes.

{% include simple_ssh/disclaimer.html %}


## Method 1 - Session and Command-line Environment Variables

The `apt` application makes use of the `HTTP_PROXY` and `HTTPS_PROXY` environment variables when present in the current execution environment. Using the example proxy IP and port mentioned earlier, the following will set the variables for the scope of a single command:

```bash
http_proxy=http://10.11.12.13:8080 https_proxy=http://10.11.12.13 apt-get update
```

Similarly, these variables can be exported as part of the terminal session as follows:

```bash
export http_proxy=http://10.11.12.13:8080
export https_proxy=http://10.11.12.13:8080
apt-get update && apt-get install -y proxytunnel
```


## Method 2 - Permanent Configuration Change

For a more permanent solution, the `/etc/apt/apt.conf.d/00aptitude` configuration file (or the `/etc/apt/apt.conf` configuration file if you prefer) can be updated with the following directive:

```bash
Acquire::http::Proxy "http://10.11.12.13:8080";
```

Once saved, `apt` commands can be run without needing to specify the environment variables mentioned earlier:
{% include bordered.html url="/assets/diagrams/apt/apt-1.png" %}



