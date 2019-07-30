#!/bin/bash
git clone https://github.com/vpervenditti/vbf
v -prod vbf/src/
mv vbf/src/vbf /usr/local/bin/vbf
rm -rf vbf
echo Done!
exit