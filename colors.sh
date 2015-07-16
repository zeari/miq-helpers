#!/bin/bash

Black='0;30'
Dark_Gray='1;30'
Blue='0;34'
Light_Blue='1;34'
Green='0;32'
Light_Green='1;32'
Cyan='0;36'
Light_Cyan='1;36'
Red='0;31'
Light_Red='1;31'
Purple='0;35'
Light_Purple='1;35'
Brown_Orange='0;33'
Yellow='1;33'
Light_Gray='0;37'
White='1;37'

Clear='\033[0m'

function printRainbow {
	if hash tput >/dev/null 2>&1; then
		bound=${1:-255}
		for (( i = 0; i < bound; i++ )); do
			echo -n "$(tput setaf $i)[${1}]$(tput sgr0)"
		done
	else
		echo "Requires tput"
		exit 1;
	fi 
}

function printRed {
	printf "\033[${Red}m${1}${Clear}\n"
}

function printGreen {
	printf "\033[${Green}m${1}${Clear}\n"
}

function printYellow {
	printf "\033[${Yellow}m${1}${Clear}\n"
}

function printBlue {
	printf "\033[${Blue}m${1}${Clear}\n"
}
