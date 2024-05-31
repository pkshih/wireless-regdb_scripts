#!/bin/bash

files="$@"

for f in $files; do
	#echo $f

	# check subject:
	#   Subject: [PATCH 1/4] wireless-regdb:
	subject=`cat $f | grep "^Subject:"`
	found=`cat $f | sed -n "s/^Subject: \[.*\] wireless-regdb:/x/p"`

	if [ "$found" == "" ]; then
		echo "Unexpected subject: $subject"
	fi
done

echo ""
echo "--to=wens@kernel.org"
echo "--cc=linux-wireless@vger.kernel.org,wireless-regdb@lists.infradead.org"
#echo "--cc=linux-wireless@vger.kernel.org"

