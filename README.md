<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="LOGO.png">
    <img src="LOGO.png" alt="Logo" width="230" height="auto">
  </a>

  <h3 align="center">Remote-Whale</h3>

  <p align="center">
    A simple script to simplify running containers remotely.
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/othneildrew/Best-README-Template">View Demo</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Report Bug</a>
    ·
    <a href="https://github.com/othneildrew/Best-README-Template/issues">Request Feature</a>
  </p>
</p>

## Table of Contents

* [About the Project](#about-the-project)
* [Getting Started](#getting-started)
  * [Prerequisites](#prerequisites)
  * [Installation](#installation)
* [Usage](#usage)
* [License](#license)
* [Acknowledgements](#acknowledgements)

### About the Project
Even though this project may seem too simple for some, there are many people that can benefit from running code on a separate machine. The idea of Remote-Whale is to allow users that may not even know about the existence of [docker](https://docker.com) to easily and quickly run containers on separate machines, without the need to move away from their precious Text Editor or IDE.

An example of that may be statisticians, that normally run very resource intensive code, but may have difficulties setting up a separate environment, as learning about docker is not in their direct study field.

The body of this project is the [vieux/docker-volume-sshfs](https://github.com/vieux/docker-volume-sshfs) plugin, you can even say that Remote-Whale is nothing but a wrapper for his plugin.

### Getting Started
#### Prerequisites
Before running the Remote-Whale script, you will need to have a few things enabled:

##### On your local computer:
* [SSH access](https://en.wikipedia.org/wiki/Secure_Shell) must be enabled (just look up how to enable it for your OS, it is generally very simple)
* [expect scripts](https://en.wikipedia.org/wiki/Expect)

##### On the Server you will use to run your code (docker host):
* [docker](https://docker.com)
* [SSH access](https://en.wikipedia.org/wiki/Secure_Shell) must be enabled
* [vieux/docker-volume-sshfs](https://github.com/vieux/docker-volume-sshfs)

#### Installation
As of now, Remote-Whale is nothing but script files. After installing the dependencies, you'll need to run the setup. To do so, run:
```sh
chmod +x setup.sh && ./setup2.sh
```


To use it, all you have to do is place `run.sh` and `run2.sh` inside you project folder and run `run.sh`. You can do that by:
```sh
chmod +x run.sh && ./run.sh
```
