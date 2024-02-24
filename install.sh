#!/bin/bash
# This is an automated tool for penetration and forensic tool installation.
# Especially for easy installation on a debian-based distribution instead of
# a full-fledged system like Kali linux.

input='list'	# List for the commands we want to install

# check the PMS
if $(command -v apt dpkg &> /dev/null)
then
    apt update
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

# Check all the commands we want to install and then install
if [ -n $input ]
then
    while read tool
    do
	echo "Checking Package..."
	if $(dpkg --list $tool &> /dev/null)
	then
	    echo "$tool is already installed"
	else
	    if $(apt-cache show $tool &> /dev/null)
	    then
		bundle+=( $tool )
	    else
		package+=( $tool )
	    fi
	fi
    done < "$input"
    apt install ${bundle[@]} -y 
else
    echo "Please enter some tool to list"
fi

# Show not founding package
if [ -n $package ]
then
    echo "${PackageNotFound[*]} not found on repository"
fi

# metasploit freamwork installation
if ! $(dpkg --list metsploit-framework)
then
    curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall
    chmod u+x msfinstall
    ./msfinstall
    rm msfinstall
fi

# Checking java on the system
if ! $(command -v openjdk-21-jre openjdk-21-jdk &> /dev/null) 
then
    apt install openjdk-21-jre openjdk-21-jdk -y 2> /dev/null 
fi

# Installation for Burp Suite
if ! $(command -v burpsuite &> /dev/null)
then
    echo -n "Installing burpsuite..."
    wget -q -O burpsuite_community_linux.sh "https://portswigger.net/burp/releases/startdownload?product=community&version=2023.12.1.5&type=Linux"
    echo "OK"
    chmod u+x burpsuite_community_linux.sh
    ./burpsuite_community_linux.sh
    rm burpsuite_community_linux.sh
else
    echo "Burp Suite is already installed"
    exit
fi

# Installation maltego
if ! $(command -v maltego &> /dev/null)
then
    echo -n "Installing maltego..."
    wget -q -O Maltego.deb https://downloads.maltego.com/maltego-v4/linux/Maltego.v4.6.0.deb 
    echo "OK"
    apt install ./Maltego.deb &> /dev/null
    rm Maltego.deb
else
    echo "maltego already installed"
fi
