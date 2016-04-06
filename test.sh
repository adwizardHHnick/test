#!/bin/bash
SERVER=http://localhost:8000

COUNT_KEYS_1=`curl $SERVER/key/remain 2> /dev/null`
if ! [[ $COUNT_KEYS_1 =~ ^[1-9][0-9]*$ ]]; then
	echo "FAIL COUNT_KEYS_1=$COUNT_KEYS_1";
	exit
fi  
	
KEY=`curl $SERVER/key/new 2> /dev/null`
if ! [[ $KEY =~ ^[0-9A-Za-z]{4}$ ]]; then
	echo "FAIL KEY=$KEY";
	exit
fi  


CHECK_KEY=`curl http://localhost:8000/key/$KEY 2> /dev/null`
if [ "$CHECK_KEY" != "NOT USED" ]; then
	echo "FAIL #1 CHECK_KEY=$CHECK_KEY"
	exit
fi

COUNT_KEYS_2=`curl $SERVER/key/remain 2> /dev/null`
if ! [[ $COUNT_KEYS_2 =~ ^[1-9][0-9]*$ ]]; then
	echo "FAIL COUNT_KEYS_2=$COUNT_KEYS_2";
	exit
fi  


if [ $((COUNT_KEYS_1 - 1)) != $COUNT_KEYS_2 ]; then
	echo "FAIL --COUNT_KEYS_1 != COUNT_KEYS_2"
	echo "FAIL $COUNT_KEYS_1 - 1 != $COUNT_KEYS_2"
	exit
fi

CHECK_KEY=`curl http://localhost:8000/key/$KEY 2> /dev/null`
if [ "$CHECK_KEY" != "NOT USED" ]; then
	echo "FAIL #2 CHECK_KEY=$CHECK_KEY"
	exit
fi

USE_KEY=`curl -X POST http://localhost:8000/key/$KEY/set_used 2> /dev/null`
if [ "$USE_KEY" != "OK" ]; then
	echo "FAIL USE_KEY=$USE_KEY"
	exit
fi

CHECK_KEY=`curl http://localhost:8000/key/$KEY 2> /dev/null`
if [ "$CHECK_KEY" != "USED" ]; then
	echo "FAIL #3 CHECK_KEY=$CHECK_KEY"
	exit
fi

COUNT_KEYS_3=`curl $SERVER/key/remain 2> /dev/null`
if ! [[ $COUNT_KEYS_3 =~ ^[1-9][0-9]*$ ]]; then
	echo "FAIL COUNT_KEYS_3=$COUNT_KEYS_3";
	exit
fi  

if [ $COUNT_KEYS_3 != $COUNT_KEYS_2 ]; then
	echo "FAIL --COUNT_KEYS_3 != COUNT_KEYS_2"
	echo "FAIL $COUNT_KEYS_3 != $COUNT_KEYS_2"
	exit
fi

echo OK
echo key $KEY
echo remain $COUNT_KEYS_3
