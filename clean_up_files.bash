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
