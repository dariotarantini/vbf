#!/bin/bash
git clone https://github.com/vpervenditti/vbf
v -prod vbf/src/.
mv vbf /usr/local/bin/vbf
rm vbf.v
echo Done!
exit