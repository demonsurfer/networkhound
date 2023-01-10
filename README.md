# NETWORK HOUND

Network Hound is an Advanced centralized server for management and data collection of malicious or unauthorised users and events on networks and servers. Network Hound allows you to deploy sensors quickly and to collect data immediately, viewable from a neat web interface. Intrusion Detection deploy scripts include several common Intrusion Detection technologies, including Conpot, ElasticHoney, Snort, Cowrie, Dionaea, and glastopf, among others.


## Features


Netork Hound is a Flask application that exposes an HTTP API that can be used to:
- Download a deploy script
- Connect and register
- Download rules
- Send intrusion detection logs

It also allows users to:

    View a list of new attacks
    Manage rules: enable, disable, download

## Installation

- The Network Hound server is supported on Ubuntu, Cent OS and other Debian based distros  


Install Git

    # on Debian or Ubuntu
    $ sudo apt install git -y
    
Install Network Hound
    
    $ cd /opt/
    $ sudo git clone https://github.com/demonsurfer/networkhound.git
    $ cd networkhound/

Run the following script to complete the installation.  While this script runs,
you will be prompted for some configuration options.  See below for how this
looks.

    $ sudo ./install.sh


   ### Configuration
   
   ![1](https://user-images.githubusercontent.com/48369752/211450243-576120a2-8f1f-42bb-9d47-8ee1bfa6ff5d.png)
   

   ### Running

  If the installation scripts ran successfully, you should have a number of
  services running on your Network Hound server.  See below for checking these.
  
  ![2](https://user-images.githubusercontent.com/48369752/211450277-467e5759-1455-46a0-a73a-b7f7a623f988.png)

![3](https://user-images.githubusercontent.com/48369752/211455870-170adc21-5285-4b57-b716-6cb40496b7f0.png)

![4](https://user-images.githubusercontent.com/48369752/211455881-780a66e2-9344-46ae-b3ed-44f2f53e967d.png)



  

  
