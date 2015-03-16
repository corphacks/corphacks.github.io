---
layout: post
title: Installing NPM and Yeoman on Ubuntu 14.10
comments: true
---

### Behind the Corporate Proxy

I'm writing this one down as it took me so long to work out. As always, the setting is a corporate environment, so the real title for this should be something like:

> __Installing NPM and Yeoman on Ubuntu 14.10 Behind a Corporate Proxy__. 

In fact, there's a lot more happening here than just NPM and Yeoman, and the title could have been more like:

> __Installing NPM, NodeJS, Grunt, Bower, Yeoman, Compass and AngularJS on an Ubuntu 14.10 Docker Container Behind a Corporate Proxy__. 

Since I am doing this an Ubuntu 14.10 Docker container, my proxy URL looks like this:

```bash
http://172.17.42.1:3128
```

Throughout this guide, when you see proxy configurations of this kind, please substitute the correct proxy host and port for your environment.

> Please Note - this guide assumes that some base utilities are available on your platform, including `curl` and `git`. These can be installed using `apt` by running:
> 
> ```bash
> apt-get install curl git -y
> ```

For details on how to get Aptitude up and running behind a proxy, please see the post: [Apt and the Corporate Proxy]({% post_url 2015-03-03-Apt-and-the-Corporate-Proxy %}).




### Credits

The following sites helped me put this post together:

- [Joyent - Installing Node.js via package manager](https://github.com/joyent/node/wiki/installing-node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions)
- [DigitalOcean - How To Install Node.js on an Ubuntu 14.04 server](https://www.digitalocean.com/community/tutorials/how-to-install-node-js-on-an-ubuntu-14-04-server)
- [JJT.io - Easy Angular development with Yeoman & generator-angular](http://jjt.io/2013/11/14/easy-angular-development-yeoman-generator-angular/)

In addition, I made use of information across a range of sites to find consistent ways of getting tools like `apt`, `npm`, `gem`, `grunt`, `bower` etc. to all work correctly behind a corporate proxy.




### Step 1 - Install Latest `nodejs` via `nodesource`

This is a variation of the steps provided on the Joyent Wiki, [Installing Node.js Via Package Manager](https://github.com/joyent/node/wiki/installing-node.js-via-package-manager#debian-and-ubuntu-based-linux-distributions), with support for interacting with a corporate proxy.


1. As the `root` user, create a new file called `/root/.curlrc` with the following contents:

    ```bash
    proxy = 172.17.42.1:3128
    ```

    Where the proxy host and port values are replaced by those from your environment. 

2. Run the setup script straight off the web using:

    ```bash
    curl -sL https://deb.nodesource.com/setup | sudo bash -
    ```

    After a successful run, the script will indicate that `apt-get install` is ready to run:

    {% include bordered.html url="/assets/diagrams/npm/nodejs-1.png" %}

3. Install `nodejs` using the following:

    ```bash
    apt-get install nodejs -y
    ```

4. Check that `npm` has installed successfully by runing `npm --version`, you should see something like this:

    {% include bordered.html url="/assets/diagrams/npm/nodejs-2.png" %}




### Step 2 - Using `npm` to Upgrade `npm`

This is one method I found worked to get `npm` upgraded to the very latest version available.

1. Create a new file called `/root/.npmrc` with the following contents:

    ```bash
    proxy = http://172.17.42.1:3128
    https-proxy = http://172.17.42.1:3128
    ```

2. Run the following to retrieve and install the latest version of `npm`:

    ```
    npm install -g npm@latest
    ```

    The output should look something like the following:

    {% include bordered.html url="/assets/diagrams/npm/npm-latest-1.png" %}

    
3. Check that the latest `npm` is available on the path by `npm --version`. A newer version number from the one reported earlier will be displayed:

    {% include bordered.html url="/assets/diagrams/npm/npm-latest-2.png" %}




### Step 3 - Install Grunt, Bower, Yeoman and the Angular Generator

1. Install the latest Grunt and Bower package by running the following:

    ```bash
    npm install -g grunt grunt-cli bower
    ```

    Check the installed versions of Grunt and Bower by running `grunt --version && bower --version`, the result should look like the following:

    {% include bordered.html url="/assets/diagrams/npm/nodetools-2.png" %}

2. Install Yeoman by running:

    ```bash
    npm install -g yo
    ```

    Check the version of Yeoman by running `yo --version`, the result should look like the following:

    {% include bordered.html url="/assets/diagrams/npm/nodetools-3.png" %}
    

3. Install the Yeoman angular project generator globally using the following:

    ```bash
    npm install -g generator-angular
    ```

    > Note the name used here, since both `generator-angular` and `angular-generator` will both return a successful result, however it is the `generator-angular` package that we want for this example.

    A successful install will look something like the following:

    {% include thumb.html url="/assets/diagrams/npm/nodetools-4.png" %}




### Step 4 - Install Compass

Our example Angular project will use `compass`, which we will install via the ruby gem. 

1. Install the following packages to get `gem` and the build tools required to install compass:

    ```bash
    apt-get install ruby-full build-essential -y
    ```

2. Create a new file called `/root/.gemrc` with the following contents:

    ```bash
    http_proxy: http://172.17.42.1:3128
    https_proxy: http://172.17.42.1:3128
    ```

3. Install `compass` by running:

    ```bash
    gem install compass --pre
    ```

    When successful, the version of compass can be checked using `compass --version`: 

    {% include bordered.html url="/assets/diagrams/npm/compass-1.png" %}




### Step 5 - Create New User for Angular Project

It is recommended that the Yeoman application, or the `yo` command, is not run by `root` as this may cause some of the tools to start complaining about security and file permissions (please see [this thread](https://github.com/yeoman/yeoman.io/issues/282) for an example of some of the issues that you may encounter when running as `root`). Instead, we will create a new user to set up the new Angular project. 

For this example, the new user will be called `developer`, however any valid username can be used here.

1. Create a new non-root user to manage the new Angular project by running:

    ```bash
    adduser --disabled-password --gecos "" developer
    ```

2. Ensure that `developer` has `sudo` access by updating `/etc/sudoers` and adding the following entry:

    ```bash
    developer ALL=(ALL) NOPASSWD: ALL
    ```

3. Switch to the `developer` user and create a new file called `~/.npmrc` with the same contents as for `root`:

    ```bash
    proxy = http://172.17.42.1:3128
    https-proxy = http://172.17.42.1:3128
    ```

4. To allow `bower` to use the proxy, create a new file called `~/.bowerrc` with the following contents:

    ```json
    {
      "proxy":"http://172.17.42.1:3128",
      "https-proxy":"http://172.17.42.1:3128"
    }
    ```

5. Lastly, still as the `developer` user, run the following to ensure that `git` also uses the proxy when called from `bower`:

    ```bash
    git config --global http.proxy http://172.17.42.1:3128
    git config --global https.proxy http://172.17.42.1:3128
    ```


### Step 6 - Start New Angular Project 

5. Still as the `developer` user, create a new project called `example` and install the generator for the project, by running:

    ```bash
    mkdir ~/example && cd ~/example
    npm install generator-angular
    ```

    > Please ignore the warning about the `~/.bowerrc` during this execution. We are choosing convenience over safety by using a global config file instead of one per project. While the suggestion is great, I can't see the corporate proxy here going away any time soon.

5. Start the generator by running:

    ```bash
    yo angular
    ```

    When prompted with questions, stick with the default settings for now. 

    Please be patient with this section as the generator installs and configures a range of packages, includeing bower and grunt, to start off the new project. 




### Step 7 - Grunt Serve

1. At this point, we can see the result of the Yeoman generated project by running:

    ```bash
    grunt serve
    ```

    {% include thumb.html url="/assets/diagrams/npm/grunt-serve-1.png" %}

    If all goes well, we will be able to visit [http://localhost:9000](http://localhost:9000) and see the following site:

    {% include thumb.html url="/assets/diagrams/npm/bootstrap-1.png" %}




### A Note About Grunt Serve on Docker

I used a docker container for the purpose of documenting this guide, with a port configuration mapping the docker host port `9000` to the container's port `9000`. Initially, my browser failed to see the `grunt serve` process as the default configuration in the `Gruntfile.js` file is set to only receive connections from the local machine. 

In order for the browser to see the `grunt serve` process through the port forwarding on the docker host, I had to update the `Gruntfile.js` configuration of the project so that the `connect` → `options` → `hostname` value on line 71 pointed to `0.0.0.0`:

{% include bordered.html url="/assets/diagrams/npm/gruntfile-1.png" %}

Then when the `grunt serve` process was restarted the site was served through to the docker host as expected.
    


    









