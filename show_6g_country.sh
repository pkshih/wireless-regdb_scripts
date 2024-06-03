#!/bin/bash

dir=`dirname $0`
now=`date +%Y%m%d_%H%M%S`
output="${dir}/output_${now}.txt"

PBAR=1

IFS=$'\n'

declare -A list_6g

. $dir/alpha2.inc.sh 
. $dir/wfa.inc.sh
. $dir/rtk.inc.sh
. $dir/ce.inc.sh

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


################ summary
n_total=0
n_db_txt=0
n_wfa=0
n_rtk=0
n_lack=0
n_lab=0
export n_total n_db_txt n_wfa n_rtk n_lack n_lab

echo "country	db.txt	wfa	rtk	LACK	lab	CE	country full" | tee -a $output
echo "-------	------	---	---	----	---	--	------------" | tee -a $output

# by db.txt
countries=`echo "${!list_6g[@]}" | sed "s/ /\n/g" | sort`

# by alpha2
#countries=`echo "${!alpha2_to_full[@]}" | sed "s/ /\n/g" | sort`

for key in $countries; do
	_alpha2=$key
	_country_full=${alpha2_to_full["$_alpha2"]}

	_6g_db_txt=${list_6g[$_alpha2]}
	_6g_wfa=${wfa_6g[$_alpha2]}
	_6g_rtk=${rtk_6g[$_alpha2]}
	_is_ce=${ce_list[$_alpha2]}

	_lack_db_txt=
	_lack_lab_help=

	if [[ "$_6g_wfa" == "1" || "$_6g_rtk" == "1" ]]; then
		if [ "$_6g_db_txt" != "1" ]; then
			_lack_db_txt=1

			if [ "$_6g_wfa" == "" ]; then
				_lack_lab_help=1
			fi
		fi
	fi

	echo "$_alpha2	$_6g_db_txt	$_6g_wfa	$_6g_rtk	$_lack_db_txt	$_lack_lab_help	$_is_ce	$_country_full" | tee -a $output

	n_total=$((n_total + 1))
	[ "$_6g_db_txt" == "1" ] && n_db_txt=$((n_db_txt + 1))
	[ "$_6g_wfa" == "1" ] && n_wfa=$((n_wfa + 1))
	[ "$_6g_rtk" == "1" ] && n_rtk=$((n_rtk + 1))
	[ "$_lack_db_txt" == "1" ] && n_lack=$((n_lack + 1))
	[ "$_lack_lab_help" == "1" ] && n_lab=$((n_lab + 1))
done

echo "-------	------	---	---	----	---	--	------------" | tee -a $output
echo "country	db.txt	wfa	rtk	LACK	lab	CE	country full" | tee -a $output
echo "$n_total	$n_db_txt	$n_wfa	$n_rtk	$n_lack	$n_lab" | tee -a $output

echo "Written to $output as well"

