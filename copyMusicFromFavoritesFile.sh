#!/bin/bash 

files="favorites.txt"
to_folder="favorites"
root_folder=""


mkdir -p $to_folder

cat ./$files | while read row; do
  file=$(basename "$row")
  cp "$root_folder$row" "$to_folder/$file"  
done

