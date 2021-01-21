#!/bin/bash

source /etc/os-release
if [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; then
    export PM='apt -y'; 
elif [ "$ID" == "fedora" ]; then
    export PM='yum -y'; 
else
    echo "no release ID." && exit
fi
function scan() {
    for x in apt yum dnf pacman emerge npm ipkg opkg 
    do
	w=`which $x 2> /dev/null`
	if [ "$w" != '' ]; then
	    tf=$w
	else
	    tf='false'
	fi
	echo -e "$x:\t$tf"
    done
}
function get() { sudo $PM install $* 2>&1; }
function log() {
    redis-cli publish "log.$PROJECT" "$1"
    mosquitto_pub -t "/log/$PROJECT" -m "$1"
    echo "[`date`][$PROJECT] $*" >> ~/.pmm.log
}

if [ "$0" == '/usr/bin/pmm' ]; then
    echo "[`date`][pmm] started." > ~/.pmm.log
    scan
    sudo $PM update 2>&1> /dev/null
    sudo $PM upgrade
    if [ "$1" != "" ] && [ "$2" != "" ]; then
	here=`pwd`
	cd ~/.pmm
	if [ ! -d "$2" ]; then
	    echo  "[`date`][pmm] cloning https://github.com/$1/$2" >> ~/.pmm.log
	    git clone https://github.com/$1/$2
	    cd $2
	else
	    echo "[`date`][pmm] already have https://github.com/$1/$2" >> ~/.pmm.log
	    cd $2
	    git pull
	fi
	chmod +x .pmm && ./.pmm && chmod -x .pmm
	sudo $PM install $PACKAGES
	cd $here
    else
	here=`pwd`
	for d in ~/.pmm/*
	do
	    echo "[`date`][pmm] visiting $d" >> ~/.pmm.log
	    cd $d
	    git pull && chmod +x .pmm && ./.pmm && chmod -x .pmm
	    echo "[`date`][pmm] leaving $d" >> ~/.pmm.log
	done
	cd $here
    fi
    echo -e "[`date`][pmm] cat ~/.pmm.log for logs.\n[`date`][pmm] Done!" >> ~/.pmm.log
    cat ~/.pmm.log
fi
