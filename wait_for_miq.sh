#!/bin/bash

set -e

PREVPWD="`dirname $0`"
source $PREVPWD/colors.sh

function clean_up {
	printRed "Error"
	exit
}

function die_error {
        set +u
	printRed "Error: $1"
        exit
}


trap clean_up SIGHUP SIGINT SIGTERM ERR
echo "Restarting evm..."


if [ "$1" == "db" ]; then
	printRed "RESETTING DB!!"
	sudo killall ruby &> /dev/null || true
	bundle exec bin/rake evm:kill || die_error 'bundle exec bin/rake evm:kill failed'
	sleep 3
	bundle exec bin/rake evm:db:reset || die_error 'bundle exec bin/rake evm:db:reset failed'
	bundle exec bin/rake evm:start
else
	bundle exec bin/rake evm:kill evm:start
fi


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
