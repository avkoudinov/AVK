#!/bin/bash
#

ch=$(curl -m 5 -I -o /dev/null -s -w '%{http_code}\n' $1)
#echo $ch

if [ $ch == 200 ]; then exit 0; else exit 1; fi

