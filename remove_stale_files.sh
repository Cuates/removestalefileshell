#!/bin/sh
#
#        File: remove_stale_files.sh
#     Created: 07/25/2020
#     Updated: 07/25/2020
#  Programmer: Cuates
#  Updated By: Cuates
#     Purpose: Remove stale files 6 hours or greater
#

# Initialize array of possible directories to clean
arr=("Directory01" "Directory02")

# Initialize date
DATE=$(date +"%d-%m-%Y %H:%M:%S")

# Loop through array
for i in ${arr[@]}
do
# Check if directory is empty
if [ $(find /var/www/html/Temp_Directory/$i/ -mindepth 0 -maxdepth 0 -type d -empty 2>/dev/null) ]; then
  # Append empty to the log file
  echo "["$DATE"]" $i "directory is empty." >> /var/www/html/Doc_Directory/remove_stale_log.txt
else
  # Else store number of files based on the find command
  count="$(find /var/www/html/Temp_Directory/$i/* -mmin +360 | wc -l)"

  # Check if number of files is equal 0
  if [ $count -eq 0 ]; then
    # Append no files to remove to the log file
    echo "["$DATE"]" "No files to remove from" $i "directory." >> /var/www/html/Doc_Directory/remove_stale_log.txt
  else
    # Else execute removal command
    find /var/www/html/Temp_Directory/$i/* -mmin +360 -exec rm {} \;

    # Append files removed to the log file
    echo "["$DATE"] Removed files from" $i "directory." >> /var/www/html/Doc_Directory/remove_stale_log.txt
  fi
fi
done