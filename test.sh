#!/bin/bash -x

function gen_seq() {

        RET='\('
        for range in $1; do
                #echo "range:"$range
                MIN=`echo $range | cut -d, -f1`
                MAX="$(expr $MIN + `echo $range | cut -d, -f2` - 1)"
                #echo minmax: $MIN $MAX
                #echo seq -s' |' $MIN $MAX
                RET="${RET}`seq -s' \|' $MIN $MAX` |"
        done
	echo "`echo ${RET} | sed 's/|$//'`\\)"
}


#gen_seq "`git diff -p -U0 HEAD^ app/views/configuration/_ui_2.html.haml | grep @@ | cut -d+ -f2 | cut -d' ' -f1`"
#gen_seq "
RANGES=`git diff -p -U0 HEAD^ app/views/configuration/_ui_2.html.haml | grep @@ | cut -d+ -f2 | cut -d' ' -f1`

POOP=`gen_seq "$RANGES"`

haml-lint app/views/configuration/_ui_2.html.haml | grep "$POOP"
