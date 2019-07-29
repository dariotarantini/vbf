#!/bin/bash
if [ "$EUID" -ne 0 ]
  then 
    echo "Please run this script as root"
    exit
fi
wget https://raw.githubusercontent.com/vpervenditti/vbf/master/src/vbf.v
v -prod vbf.v
sudo mv vbf /usr/local/bin/vbf
rm vbf.v
echo Done!
exit