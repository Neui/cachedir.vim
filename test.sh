#!/bin/sh

run_test() {
	vim -N -n -i NONE -e -s -u "test/vimrc" \
			"+Test $1" "+cquit!"
	return $?
}

NGOOD=0
NFAIL=0

#find test -name '*.vim' -type f | while read line; do
for line in $(find test -name '*.vim' -type f); do
	#echo "  Running $line"
	if run_test "$line"; then
		echo "  $line OK"
		NGOOD=$(($NGOOD+1))
	else
		echo ""
		echo "X $line FAILED!!!"
		NFAIL=$(($NFAIL+1))
	fi
done

NTOTAL=$(($NGOOD+$NFAIL))
echo ""
echo "STATUS: $NFAIL/$NGOOD/$NTOTAL (fail/success/total)"

test $NFAIL != 0 && exit 1
exit 0
