#!/usr/bin/env bash

## This script has been meant to create log with a certain given mask
## It will create fake logs for testing purposes.
## JFM's ass will be mine.

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
 pato@Patricios-MacBook-Pro  ~/Scripts  ll
total 1024
-rw-r--r--   1 pato  staff   206K May 12 18:44 basename
-rwxr-xr-x   1 pato  staff   1.4K May 11 20:33 fake_log_generator.bash
-rwxr-xr-x   1 pato  staff   5.4K May 12 16:22 jfm.bash
-rw-r--r--   1 pato  staff   3.8K May 12 15:52 jfm.bash_1557687162.log
-rw-r--r--   1 pato  staff   3.8K May 12 15:55 jfm.bash_1557687302.log
-rw-r--r--   1 pato  staff   4.0K May 12 15:56 jfm.bash_1557687373.log
-rw-r--r--   1 pato  staff   4.0K May 12 15:56 jfm.bash_1557687391.log
-rw-r--r--   1 pato  staff   4.0K May 12 15:59 jfm.bash_1557687575.log
-rw-r--r--   1 pato  staff   4.0K May 12 16:00 jfm.bash_1557687611.log
-rw-r--r--   1 pato  staff   4.0K May 12 16:02 jfm.bash_1557687758.log
-rw-r--r--   1 pato  staff   4.0K May 12 16:03 jfm.bash_1557687782.log
-rw-r--r--   1 pato  staff   4.0K May 12 16:03 jfm.bash_1557687802.log
-rw-r--r--   1 pato  staff   4.0K May 12 16:05 jfm.bash_1557687923.log
-rw-r--r--   1 pato  staff   3.8K May 12 16:09 jfm.bash_1557688181.log
-rw-r--r--   1 pato  staff    12K May 12 16:13 jfm.bash_1557688416.log
-rw-r--r--   1 pato  staff    12K May 12 16:14 jfm.bash_1557688440.log
-rw-r--r--   1 pato  staff    12K May 12 16:15 jfm.bash_1557688508.log
-rw-r--r--   1 pato  staff    12K May 12 16:15 jfm.bash_1557688555.log
-rw-r--r--   1 pato  staff    11K May 12 16:16 jfm.bash_1557688597.log
-rw-r--r--   1 pato  staff    12K May 12 16:17 jfm.bash_1557688625.log
-rw-r--r--   1 pato  staff    12K May 12 16:17 jfm.bash_1557688676.log
-rw-r--r--   1 pato  staff    13K May 12 16:18 jfm.bash_1557688708.log
-rw-r--r--   1 pato  staff    13K May 12 16:19 jfm.bash_1557688753.log
-rw-r--r--   1 pato  staff    12K May 12 18:44 jfm.bash_1557697481.log
drwxr-xr-x  23 pato  staff   736B May 12 18:44 logs
-rwxr-xr-x   1 pato  staff   670B Mar 27 21:10 search2error.bash
-rwxr-xr-x   1 pato  staff   850B Apr 11 14:05 test_getopts.bash
 pato@Patricios-MacBook-Pro  ~/Scripts  cat jfm.bash
#!/usr/bin/env bash

##========================================================================
## Introduction
##========================================================================
## This script has been meant and written to clean up files on a certain paths.
## You can define masks for files in order to remove or compress many at a time.
## We will drive this using functions for beeing more generic.
## Due to bash limitation on array multidimensional, we try to simulate that behaviour.
## JFM has met B3t0 long time ago but still in love.
##========================================================================

##========================================================================
## Some Global Variables
##========================================================================
script_name="basename $0"

log_date=`date +%s`
log_dir="./"
log_file="${script_name}_${log_date}.log"

ls_cmd=`which ls`
rm_cmd=`which rm`
gzip_cmd=`which gzip`
tee_cmd=`which tee`
find_cmd=`which find`
cut_cmd=`which cut`
rev_cmd=`which rev`
basename_cmd=`which basename`
dirname_cmd=`which dirname`

compress_policy_days="+1"
remove_policy_days="+30"
clean_up="\
/Users/pato/Scripts/logs/apache* \
/Users/pato/Scripts/another*"

##========================================================================
## Some Functions (each one introduced with a little header)
##========================================================================
: '································································
Log strings to file (also multiline):

      - given string *

    [*] =  Mandatory
··································································'
log2file () {

  local time_stamp=`date "+%F %T"`

  if [ -z "${1}" ]
  then
    echo "${time_stamp} - The string cannot be empty for log2file function." | ${tee_cmd} -a ${log_file}
    exit 100
  else
    local message2log="${1}"
  fi

  echo "${time_stamp} - ${message2log}" | ${tee_cmd} -a ${log_file}

}

: '
································································
Compress file/s on:

      - given Path
      - given File Mask
      - given time in day to compress, either more or less than X days.

   [*] = Mandatory
··································································'
compress_files () {

  local gzip_path=${1}
  local file_mask=${2}
  local gzip_policy_days=${3}

  log2file "==================================================================="
  log2file "Compressing files"
  log2file "==================================================================="
  log2file "The PATH to COMPRESS is          : ${gzip_path}"
  log2file "The FILE to COMPRESS is          : ${file_mask}"
  log2file "The DAYS to COMPRESS is/are      : ${gzip_policy_days}"

  if [ -z "${gzip_path}" ]; then log2file "The 'PATH' cannot be empty"; exit 200; fi
  if [ -z "${file_mask}" ]; then log2file "The 'FILE' to GZIP cannot be empty"; exit 201; fi
  if [ -z "${gzip_policy_days}" ]; then log2file "You must specify the 'DAYS|MINS' to remove"; exit 202; fi

  file2gzip=`${find_cmd} "${gzip_path}" -name "${file_mask}" -mtime "${gzip_policy_days}" -exec ${ls_cmd} -1 {} \;`


  if [ -z "${file2gzip}" ]
  then
    log2file "There is no file/s to compress."
  elif [ `echo "${file2gzip}" | $rev_cmd | ${cut_cmd} -d "." -f1 | rev` == "gz" ]
  then
    log2file "The file is already COMPRESSED : ${file_mask}"
  else
    log2file "${file2gzip}"
    ${find_cmd} "${gzip_path}" -name "${file_mask}" -mtime "${gzip_policy_days}" -exec ${gzip_cmd} --best --quiet {} \;
  fi

  log2file "==================================================================="

}

: '································································
Remove file/s on:

      - given Path
      - given File Mask
      - given time in day to remove, either more or less than X days.

   [*] = Mandatory
··································································'

: '································································
MAIN:

   In here we will remove the files.
··································································'
for what2remove in ${clean_up}
do
  file_mask_cut=`${basename_cmd} "${what2remove}"`
  path_cut=`${dirname_cmd} "${what2remove}"`

  compress_files "${path_cut}" "${file_mask_cut}" "${compress_policy_days}"
  #  remove_files "${path_cut}" "${file_mask_cut}" "${remove_policy_days}"


done
