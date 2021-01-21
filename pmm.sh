$!/bin/bash

source /etc/os-release 
if [ "$ID" == "debian" ] || [ "$ID" == "ubuntu" ]; 
  then export PM='apt -y'; 
  elif [ "$SYS" == "fedora" ]; 
  then export PM='yum -y'; 
  else echo "no release ID." && exit 
fi
sudo $PM *$
