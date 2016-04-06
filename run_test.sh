#!/bin/bash


COUNTER=10000000
until [  $COUNTER -lt 1 ]; do
	let COUNTER-=1
	RESULT=`bash ./test.sh`
	echo $RESULT
	echo remain: $COUNTER
	if ! [[ $RESULT =~ ^OK ]]; then
		echo "FAIL";
		exit
	fi  
done
