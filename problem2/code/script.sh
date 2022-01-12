#!/bin/bash
rm ./result
for i in `cat file`
do

key=$i
value=`curl  http://169.254.169.254/2007-01-19/meta-data/"$i"`

echo " $key = $value " >> result
done
python jsonscript.py
cp output2.json /var/www/html/