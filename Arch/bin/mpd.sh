#!/bin/bash 

cur=`mpc current`
test -n "$cur" && echo $cur || echo "- stopped -"
