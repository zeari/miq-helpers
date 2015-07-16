#!/bin/bash

set -e
set -u

source colors.sh

function clean_up {
	printRed "Error"
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM ERR


echo Waiting for miq
DIFF=0
START=$(date +%s.%N)
until curl 127.0.0.1:3000 &>/dev/null; do
	sleep 3
	END=$(date +%s.%N)
	DIFF=$(echo "$END - $START" | bc)
	printYellow "Waiting... $DIFF"
done


echo -e "\a"
sleep 0.1
echo -e "\a"
echo -e "\a"
sleep 0.1
echo -e "\a"
sleep 0.1
echo -e "\a"
sleep 0.1
printBlue "Done. Waited $DIFF years for miq."
