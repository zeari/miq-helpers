#!/bin/bash

set -e

PREVPWD="`dirname $0`"
source $PREVPWD/colors.sh

usage="murphy.sh [REF]
REF can be HEAD^ or HEAD~4"

function clean_up {
        printRed "Error"
        exit
}

trap clean_up SIGHUP SIGINT SIGTERM ERR

function die_error {
	set +u
        printRed "Error: $1"
        exit
}

# Generates a part of a regex for filtering line numbers - '(43|47||45...)'
function gen_seq() {
        RET='\('
        for range in $1; do
                #echo "range:"$range
                MIN=`echo $range | cut -d, -f1`
                MAX="$(expr $MIN + `echo $range | cut -d, -f2` - 1)"
                #echo minmax: $MIN $MAX
                #echo seq -s' |' $MIN $MAX
                RET="${RET}`seq -s'\|' $MIN $MAX`\\|"
        done
	echo "${RET})" | sed s/\|\)$/\)/g
}



eval "git rev-parse" &> /dev/null ||  die_error "Change dir into a git repo."

if ! type haml-lint > /dev/null; then
	die_error "haml-lint not found. Please install with \'gem install haml-lint\'"
fi 

if ! type unbuffer > /dev/null; then
	die_error "unbuffer not found. Please install with \'sudo yum install expect\'"
fi 


REF="$1"
set -u

if [ -z "$REF" ]; then
	REF="HEAD^"
fi

printGreen "Using $REF as reference."
echo "" 

printYellow "Running rubocop..." 
$PREVPWD/rubocop.rb --against HEAD^ -c $PREVPWD/.rubocop.yml 

echo ""
printYellow "Running haml-lint..."
HAMLS=`git diff --diff-filter=AM --name-only ${REF} | grep haml`

for haml in $HAMLS; do
	RANGES=`git diff -p -U0 $REF $haml| grep @@ | cut -d+ -f2 | cut -d' ' -f1`
	SEQ_STRING=`gen_seq "$RANGES"`
	#echo haml-lint $haml \| grep --color=never "${SEQ_STRING}" || true
	unbuffer haml-lint $haml | grep --color=never "m${SEQ_STRING}\b" || true
done

echo ""
echo -n -e '\a'
sleep 0.1
echo -n -e '\a'
echo -n -e '\a'
sleep 0.1
echo -n -e '\a'
sleep 0.1
echo -n -e '\a'
sleep 0.1
printBlue "All done!"
