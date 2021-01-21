#!/bin/bash
source /etc/os-release
if [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; then
    export PM='apt -y'; 
elif [ "$ID" == "fedora" ]; then
    export PM='yum -y'; 
else
    echo "no release ID." && exit
fi
function get() { sudo $PM install $*; }
function log() {
    redis-cli publish "log.$PROJECT" "$1" > /dev/null
    mosquitto_pub -t "/log/$PROJECT" -m "$1" > /dev/null
    echo "[`date`][$PROJECT] $*" >> ~/.pmm.log
}

if [ "$0" == '/usr/bin/pmm' ]; then
    echo "[pmm] `date`" > ~/.pmm.log
    sudo $PM update
    sudo $PM upgrade
    if [ "$1" != "" ] && [ "$2" != "" ]; then
	here=`pwd`
	cd ~/.pmm
	if [ ! -d "$2" ]; then
	    git clone https://github.com/$1/$2
	    cd $2
	else
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
	    echo "found $d"
	    cd $d
	    git pull && chmod +x .pmm && ./.pmm && chmod -x .pmm
	done
	cd $here
    fi
    echo "[`date`][pmm] cat ~/.pmm.log for logs.\n[`date`][pmm] Done!"
    cat ~/.pmm.log
fi
