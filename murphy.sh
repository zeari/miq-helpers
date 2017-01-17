#!/bin/bash

set -e

PREVPWD="`dirname $0`"
source $PREVPWD/colors.sh
NEWLINE=$'\n'

function usage() {
	printGreen 'usage: murphy.sh [REF]'
	printGreen '       REF can be HEAD^^ or HEAD~4. It defaults to HEAD^.'
}

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


while getopts :h: FLAG; do
  case $FLAG in
    h)  #show help
      usage
      exit
      ;;
    \?) #unrecognized option - show help
      echo -e \\n"Unknown option -${BOLD}$OPTARG${NORM}."
      usage
      exit 2
      ;;
  esac
done

shift $((OPTIND-1))  #This tells getopts to move on to the next argument.


eval "git rev-parse" &> /dev/null ||  die_error "Change dir into a git repo."

if ! type haml-lint > /dev/null; then
	if ! type unbuffer > /dev/null; then
		die_error "haml-lint and unbuffer not found. Please install with \'gem install haml-lint\' \'sudo yum install expect\'"
		
	else
		die_error "haml-lint not found. Please install with \'gem install haml-lint\'"
	fi
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

printBlue "Running rubocop..."
echo -e Using "\033[${Yellow}m`pwd`/.rubocop.yml${Clear}\n"
$PREVPWD/rubocop.rb --against $REF -c .rubocop.yml  || true


HAMLS=`git diff --diff-filter=AM --name-only ${REF} | grep haml || true` 
NUM_HAMLS=`echo $HAMLS |  wc -w`


if [ $NUM_HAMLS -gt 0 ]; then
	echo ""
	printBlue "Running haml-lint..."


	echo Inspecting $NUM_HAMLS files
	OFFENCES="0"

	LINES=""
	for haml in $HAMLS; do
		RANGES=`git diff -p -U0 $REF $haml| grep @@ | cut -d+ -f2 | cut -d' ' -f1`
		SEQ_STRING=`gen_seq "$RANGES"`
		TMP=`unbuffer haml-lint $haml | grep --color=never "m${SEQ_STRING}\b" || true`
		LINES="${LINES}${NEWLINE}${TMP}"
		echo -ne '.'
	done

	echo ""
	echo ""

	OFFENCES=`echo $LINES |  sed '/^$/d' |  wc -l`

	echo ""

	if [ 0 -eq $OFFENCES ]; then
		echo -ne "$NUM_HAMLS files inspected, "
		printGreen "$OFFENCES offenses detected"
	else
		echo "Offences: ${NEWLINE}"
		echo "${LINES}"
		echo ""
		echo -ne "$NUM_HAMLS files inspected, "
		printRed "$OFFENCES offenses detected"
	fi
fi

#notify-send "Murphy: $OFFENCES offenses detected"
notify-send "Murphy: All Done!"

echo ""
printBlue "All done!"
