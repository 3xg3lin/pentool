#!/bin/bash
#
input='list'
if $(command -v apt dpkg &> /dev/null)
then
    pms='apt'
    $pms update
else
    echo "Only Debian-based distro"
    exit
fi

if [ -n $input ]
then
    while read tool
    do
	if $(dpkg --list $tool)
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

if ! $(command -v curl && command -v wget)
then
    $pms install curl wget
fi

if [ "$(curl -s -o /dev/null -w "%{http_code}" "https://portswigger.net/burp/releases/professional-community-2023-12-1-5")" -eq "200%" ]
then
    echo -n "Installing burpsuite..."
    wget -O burpsuite_community_linux.sh "https://portswigger.net/burp/releases/startdownload?product=community&version=2023.12.1.5&type=Linux"
    echo "OK"
else
    echo "Please install new version of burpsuite"
    firefox "https://portswigger.net/burp/releases/community/latest"
    exit
fi


