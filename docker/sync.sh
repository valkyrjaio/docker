#!/bin/bash

replaceSyncWith=site
syncDir="/var/www/sync/"

inotifywait -m -r -e modify,create,move "${syncDir}app" "${syncDir}bootstrap" "${syncDir}config" "${syncDir}framework" "${syncDir}public" "${syncDir}resources" "${syncDir}routes" "${syncDir}storage" |
while read -r directory events filename; do
    if [[ $filename != *"tmp"* ]]
    then
        mkdir -p "${directory/sync/$replaceSyncWith}"
        cp "$directory$filename" "${directory/sync/$replaceSyncWith}$filename"
        echo -e "\e[95m$directory$filename changed\e[0m"
    fi
done
