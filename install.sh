#!/bin/bash

if [ "$(whoami)" != "root" ]
then
    echo -e "You must be root to run this script"
    exit 1
fi

if [[ $# -eq "1" && $1 -eq "0" ]]
then
    echo "Running in unattended mode. Assuming config.py exists. Splunk, ELK and UFW will be skipped."
    hound_SERVER_SCRIPT="install_houndserver_unattended.sh"
    UNATTENDED=true
elif [[ $# -eq "1" && $1 -eq "1" ]]
then
    echo "Running in attended mode (config.py not created)"
    hound_SERVER_SCRIPT="install_houndserver.sh"
    UNATTENDED=false
else
    hound_SERVER_SCRIPT="install_houndserver.sh"
    UNATTENDED=false
fi

set -e
set -x

hound_HOME=`dirname "$(readlink -f "$0")"`
WWW_OWNER="www-data"
SCRIPTS="$hound_HOME/scripts/"
cd $SCRIPTS

if [ -f /etc/redhat-release ]; then
    export PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:$PATH
    #yum updates + health
    yum clean all -y
    yum update -y

    #Dump yum info for troubleshooting
    echo -e "Yum Repo List:\n"
    yum repolist
    echo -e "Yum Dev Group Packages:\n"
    yum grouplist | grep -i development
    echo -e "Attempting to install Dev Tools"
    yum groupinfo mark install "Development Tools"
    yum groupinfo mark convert "Development Tools"
    yum groupinstall "Development Tools" -y
    echo -e "Development Tools successfully installed\n"

    WWW_OWNER="nginx"
    ./install_sqlite.sh

    if [ ! -f /usr/local/bin/python2.7 ]; then
        echo "[`date`] Installing Python2.7 as a pre-req"
       ./install_python2.7.sh
    fi

     ./install_supervisord.sh
fi

if [ -f /etc/debian_version ]; then
    apt-get update && apt-get upgrade -y
    apt-get install -y python-pip
    pip install --upgrade pip
    apt-get install apt-transport-https -y
    apt-get install build-essential -y #needed for building some python modules
fi

echo "[`date`] Starting Installation of all hound packages"

echo "[`date`] ========= Installing hpfeeds ========="
 ./install_hpfeeds.sh

echo "[`date`] ========= Installing menmosyne ========="
 ./install_mnemosyne.sh

echo "[`date`] ========= Installing Honeymap ========="
 ./install_honeymap.sh

echo "[`date`] ========= Installing hound Server ========="
 ./$hound_SERVER_SCRIPT

echo "[`date`] ========= hound Server Install Finished ========="
echo ""

if [ $UNATTENDED = false ]
then
    while true;
    do
        echo -n "Would you like to integrate with Splunk? (y/n) "
        read SPLUNK
        if [ "$SPLUNK" == "y" -o "$SPLUNK" == "Y" ]
        then
            echo -n "Splunk Forwarder Host: "
            read SPLUNK_HOST
            echo -n "Splunk Forwarder Port: "
            read SPLUNK_PORT
            echo "The Splunk Universal Forwarder will send all hound logs to $SPLUNK_HOST:$SPLUNK_PORT"
            ./install_splunk_universalforwarder.sh "$SPLUNK_HOST" "$SPLUNK_PORT"
            ./install_hpfeeds-logger-splunk.sh
            break
        elif [ "$SPLUNK" == "n" -o "$SPLUNK" == "N" ]
        then
            echo "Skipping Splunk integration"
            echo "The splunk integration can be completed at a later time by running this:"
            echo "    cd /opt/hound/scripts/"
            echo "    sudo ./install_splunk_universalforwarder.sh <SPLUNK_HOST> <SPLUNK_PORT>"
            echo "    sudo ./install_hpfeeds-logger-splunk.sh"
            break
        fi
    done


    while true;
    do
        echo -n "ELK Script will only work on Debian Based systems like Ubuntu"
        echo -n "Would you like to install ELK? (y/n) "
        read ELK
        if [ "$ELK" == "y" -o "$ELK" == "Y" ]
        then
            ./install_elk.sh
            break
        elif [ "$ELK" == "n" -o "$ELK" == "N" ]
        then
            echo "Skipping ELK installation"
            echo "The ELK installation can be completed at a later time by running this:"
            echo "    cd /opt/hound/scripts/"
            echo "    sudo ./install_elk.sh"
            break
        fi
    done


    while true;
    do
        echo -n "A properly configured firewall is highly encouraged while running hound."
        echo -n "This script can enable and configure UFW for use with hound."
        echo -n "Would you like to add hound rules to UFW? (y/n) "
        read UFW
        if [ "$UFW" == "y" -o "$UFW" == "Y" ]
        then
            ./enable_ufw.sh
            break
        elif [ "$UFW" == "n" -o "$UFW" == "N" ]
        then
            echo "Skipping UFW configuration"
            echo "The UFW configuration can be completed at a later time by running this:"
            echo "    cd /opt/hound/scripts/"
            echo "    sudo ./enable_ufw.sh"
            break
        fi
    done
fi
chown $WWW_OWNER /var/log/hound/hound.log

chown $WWW_OWNER /var/log/hound/hound.log
supervisorctl restart hound-celery-worker

echo "[`date`] Completed Installation of all hound packages"
