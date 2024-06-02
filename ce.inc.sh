#!/bin/bash

dir=`dirname $0`

ce_file="$dir/ce.txt"

declare -A ce_list

[ "$PBAR" == "1" ] && echo -n "build ce_6g "

[ "$HAS_ALPHA2" != "1" ] && . $dir/alpha2.inc.sh

while read line; do
	_country=`echo "$line" | cut -f 1`
	_country_alpha2="${full_to_alpha2[$_country]}"
	if [ "$_country_alpha2" == "" ]; then
		echo -e "\n\tce unknwon country $_country"
		_country_alpha2="97"
	fi

	ce_list["$_country"]=1
	ce_list["$_country_alpha2"]=1

	[ "$PBAR" == "1" ] && echo -n "."
done < $ce_file

[ "$PBAR" == "1" ] && echo " Done"
