#!/bin/bash

dir=`dirname $0`

PBAR=1

IFS=$'\n'

declare -A list_6g

. $dir/alpha2.inc.sh 
. $dir/wfa.inc.sh

### check if wfa country missed

for country_full in "${!wfa_6g[@]}"; do
	alpha2=${full_to_alpha2[$country_full]}
	[ "$alpha2" == "" ] && echo "unknown WFA country: $country_full"
done

###

while read -r line; do
	comment=`echo "$line" | sed "s/^[ \t]*#.*$//"`
	[ "$comment" == "" ] && continue

	country_tmp=`echo "$line" | sed -n "s/^country \([A-Z][A-Z]\):.*/\1/p"`
	[ "$country_tmp" != "" ] && country=$country_tmp && country_6g=0 # && echo $country

	freq_range=`echo "$line" | sed -n "s/^[ \t]*(\([0-9]*\) - \([0-9]*\) .*/\1\t\2/p"`
	if [ "$freq_range" != "" ]; then
		freq1=`echo $freq_range | cut -f 1`
		freq2=`echo $freq_range | cut -f 2`

		is_6g=$((freq1 <= 6000 && freq2 > 6000 ? 1 : 0))

		#echo "$freq1  $freq2    6g=$is_6g"

		if [ "$is_6g" == "1" ]; then
			country_6g=1
		fi
	fi

	[ "$country" != "" ] && list_6g[$country]=0
	[ "$country_6g" == "1" ] && list_6g[$country]=1

	#echo "$country	$country_6g"

	#echo -e "$line"

	[ "$PBAR" == "1" ] && echo -n "."
done < db.txt

[ "$PBAR" == "1" ] && echo ""

echo "country	db.txt	wfa	country full"
echo "-------	------	---	------------"

for key in "${!list_6g[@]}"; do
	country_full=${alpha2_to_full["$key"]}
	echo "$key	${list_6g[$key]}	${wfa_6g[$country_full]}	$country_full"
done | sort


