#!/bin/bash
# This is an automated tool for penetration and forensic tool installation.
# Especially for easy installation on a debian-based distribution instead of
# a full-fledged system like Kali linux.

input='list'	# List for the commands we want to install

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
    $pms install ${bundle[@]} -y 
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

