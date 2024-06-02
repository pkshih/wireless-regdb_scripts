#!/bin/bash

dir=`dirname $0`

rtk_file="$dir/rtk.txt"

declare -A rtk_6g

[ "$PBAR" == "1" ] && echo -n "build rtk_6g "

[ "$HAS_ALPHA2" != "1" ] && . $dir/alpha2.inc.sh

while read line; do
	# three kinds of values:
	# Colombia        Y
	# Nicaragua       N

	_country=`echo "$line" | cut -f 1`
	_adopt=`echo "$line" | cut -f 2`

	_country_alpha2="${full_to_alpha2[$_country]}"
	if [ "$_country_alpha2" == "" ]; then
		echo -e "\n\trtk unknwon country $_country"
		_country_alpha2="99"
	fi

	if [ "$_adopt" == "Y" ]; then
		rtk_6g["$_country"]=1
		rtk_6g["$_country_alpha2"]=1
	elif [ "$_adopt" == "N" ]; then
		rtk_6g["$_country"]=0
		rtk_6g["$_country_alpha2"]=0
	else
		echo "Unknwon rtk condition $_adopt for $_country"
	fi

	[ "$PBAR" == "1" ] && echo -n "."
done < $rtk_file

[ "$PBAR" == "1" ] && echo " Done"

#echo ${rtk_6g["Luxembourg"]}

