#!/bin/bash

syncDir="/var/www/sync"
siteDir="/var/www/site"

echo -e "\e[96mCopying sync to site\e[0m"
cp -r $syncDir $siteDir
