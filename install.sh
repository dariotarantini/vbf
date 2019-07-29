#!/bin/bash
wget https://raw.githubusercontent.com/vpervenditti/vbf/master/src/vbf.v
v -prod vbf.v
mv vbf /usr/local/bin/vbf
rm vbf.v
echo Done!
exit