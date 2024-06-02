#!/bin/bash

dir=`dirname $0`

wfa_file="$dir/wfa.txt"

declare -A wfa_6g

[ "$PBAR" == "1" ] && echo -n "build wfa_6g "

[ "$HAS_ALPHA2" != "1" ] && . $dir/alpha2.inc.sh

while read line; do
	# three kinds of format:
	# 1. Andorra Adopted Considering     5945-6425 MHz 6425-7125 MHz
	# 2. Brazil  Adopted 5925-7125 MHz
	# 3. Tunisia Considering     5925-6425 MHz

	_country=`echo "$line" | cut -f 1`
	_adopt=`echo "$line" | cut -f 2 | grep Adopted`
	_consider=`echo "$line" | cut -f 3 | grep Consider`

	_country_alpha2="${full_to_alpha2[$_country]}"
	if [ "$_country_alpha2" == "" ]; then
		echo -e "\n\tWFA unknwon country $_country"
		_country_alpha2="98"
	fi

	if [ "$_adopt" == "" ]; then
		_freq_range=""
	elif [ "$_consider" != "" ]; then
		_freq_range=`echo "$line" | cut -f 4`
	else
		_freq_range=`echo "$line" | cut -f 3`
	fi

	if [ "$_freq_range" != "" ]; then
		wfa_6g["$_country"]=1
		wfa_6g["$_country_alpha2"]=1
	fi

	[ "$PBAR" == "1" ] && echo -n "."
done < $wfa_file

[ "$PBAR" == "1" ] && echo " Done"

#echo ${wfa_6g["Luxembourg"]}

