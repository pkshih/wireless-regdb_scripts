#!/bin/bash

dir=`dirname $0`

alpha2_file="$dir/alpha2.txt"

declare -A alpha2_to_full
declare -A full_to_alpha2

[ "$PBAR" == "1" ] && echo -n "build alph2 "

while read line; do
	_alpha2=`echo "$line" | cut -f 1`
	_full=`echo "$line" | cut -f 2`

	alpha2_to_full["$_alpha2"]="$_full"
	full_to_alpha2["$_full"]="$_alpha2"

	[ "$PBAR" == "1" ] && echo -n "."
done < $alpha2_file

[ "$PBAR" == "1" ] && echo " Done"

#echo ${alpha2_to_full["US"]}

HAS_ALPHA2=1

