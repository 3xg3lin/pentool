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
	    $pms install $bundle
	fi
    done < "$input"
else
    echo "Please enter some tool to list"
fi




