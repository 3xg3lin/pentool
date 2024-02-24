#!/bin/bash
#
input='list' # List for the commands we want to install

# check the PMS
if $(command -v apt dpkg &> /dev/null)
then
    pms='apt'
    $pms update
else
    echo "Only Debian-based distro"
    exit
fi

# Checking curl and wget command 
if ! $(command -v curl wget &> /dev/null)
then
    echo curl >> $input
    echo wget >> $input
fi


# Check all the commands we wnat to install and then install
if [ -n $input ]
then
    while read tool
    do
	if $(dpkg --list $tool &> /dev/null)
	then
	    echo "$tool is already installed"
	else
	    bundle=($tool )
	fi
    done < "$input"
    $pms install $bundle -y
else
    echo "Please enter some tool to list"
fi

# Installation for Burp Suite
if ! $(command -v burpsuite &> /dev/null)
then
    echo -n "Installing burpsuite..."
    wget -q -O burpsuite_community_linux.sh "https://portswigger.net/burp/releases/startdownload?product=community&version=2023.12.1.5&type=Linux"
    echo "OK"
    chmod u+x burpsuite_community_linux.sh
    ./burpsuite_community_linux.sh
else
    echo "Burp Suite is already installed"
    exit
fi

