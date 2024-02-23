#!/bin/bash
#
input='list' # List for the commands we want to install

if $(command -v apt dpkg &> /dev/null)
then
    pms='apt'
    $pms update
else
    echo "Only Debian-based distro"
    exit
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
	    $pms install $bundle -y
	fi
    done < "$input"
else
    echo "Please enter some tool to list"
fi
# Checking curl and wget command 
if ! $(command -v curl wget &> /dev/null)
then
    $pms install curl wget -y
fi
# Installation for Burp Suite
if [ $(curl -s -o /dev/null -w "%{http_code}" "https://portswigger.net/burp/releases/professional-community-2023-12-1-5"|sed "s/%//g") -eq "200" ]
then
    echo -n "Installing burpsuite..."
    wget -q -O burpsuite_community_linux.sh "https://portswigger.net/burp/releases/startdownload?product=community&version=2023.12.1.5&type=Linux"
    echo "OK"
else
    echo "Please install new version of burpsuite"
    firefox "https://portswigger.net/burp/releases/community/latest"
    exit
fi


