#!/bin/bash
if [ "$EUID" -ne 0 ]
  then 
    echo "Please run this script as root"
    exit
fi 
git clone https://github.com/vpervenditti/vbf
rm -rf .a.out
rm -rf /usr/local/bin/vbf
v -prod ./vbf/vbf/.
mv .a.out /usr/local/bin/vbf
rm -rf vbf
echo Done!
exit
