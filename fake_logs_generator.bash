#!/usr/bin/env bash

## This script has been meant to create log with a certain given mask
## It will create fake logs for testing purposes.

## Some Functions

menu () {

  clear

  ## Print a couple of empty lines
  echo ""
  echo ""

  ## Request the file/s mask.
	echo -n "| 1 | Enter the file mask of the file you want to create       : "
	read file_mask

	## Request a file extension if desired.
	echo -n "| 2 | Enter the file extension of the file you want            : "
	read file_extension

	## Request the quantity of file to create.
	echo -n "| 3 | Enter how many files you want to create                  : "
	read files_qty

	## Request the path were to place the logs
	echo -n "| 4 | Enter the PATH were you want to create them all          : "
	read path_location
	if [ ! -d ${path_location} ]; then mkdir ${path_location}; fi

  ## Enter the timestamp for the file to generate
  echo -n "| 5 | Enter the date@time to generate the files (YYYYMMDDHHMM) : "
  read time_stamp
}

# Run the menu.
menu

## Iterate to generate the needed logs.
for (( i = 0; i <= ${files_qty}; i++ ))
do
  file2create="${path_location}/${file_mask}${i}${file_extension}"

  if [ ! -e ${file2create} ]
  then
    echo "${i}" > ${file2create}
    if [ ! -z ${time_stamp} ]; then touch -t ${time_stamp} ${file2create}; fi
  else
    echo "The file '${file2create}' is already in the path '${path_location}'"
  fi
done
