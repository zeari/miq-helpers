#!/bin/bash

files="
colors.sh
murphy.sh
rubocop.rb
.rubocop.yml
"

mkdir -p export
rm -r murphy.tar.gz

for i in $files; do
	cp $i export
done

tar cvzf murphy.tar.gz export

rm -r export

