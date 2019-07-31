#!/bin/bash
if [ "$EUID" -ne 0 ]
  then 
    echo "Please run this script as root"
    exit
fi
rm -rf vbf.v
rm -rf /usr/local/bin/vbf
wget https://raw.githubusercontent.com/vpervenditti/vbf/master/vbf/vbf.v
v -prod vbf.v
mv vbf /usr/local/bin/vbf
rm -rf vbf
echo Done!
exit