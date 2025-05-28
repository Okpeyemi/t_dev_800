#!/bin/sh

set -ex

cd $1
for folder in *; do 
    echo "$folder"
    mkdir -p "$folder/BACTERIA" "$folder/VIRUS"
    find "$folder/PNEUMONIA" -type f | grep virus | xargs -i cp {} "$folder/VIRUS/"
    find "$folder/PNEUMONIA" -type f | grep bacteria | xargs -i cp {} "$folder/BACTERIA/"
    rm -rf "$folder/PNEUMONIA"
done
