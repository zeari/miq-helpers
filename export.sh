#!/bin/bash

files="
colors.sh
murphy.sh
rubocop.rb
.rubocop.yml
wait_for_miq.sh
"

mkdir -p murphy
rm -r murphy.tar.gz

for i in $files; do
	cp $i murphy
done

tar cvzf murphy.tar.gz murphy

rm -r murphy

