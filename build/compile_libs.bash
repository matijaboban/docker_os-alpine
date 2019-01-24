#!/bin/bash

## default values
config=/tmp/workspace/config.yaml
scr=~/project/build/compiled/packages-install.sh


while getopts c:s:t: option
do
    case "${option}"
    in
        c) config=${OPTARG};;
        s) scr=${OPTARG};;
        t) tag=${OPTARG};;
    esac
done

##
if [ -z "$tag" ]
then
      echo "Docker tag was not specified via -t."
      exit 1
fi

# echo $tag

## empty config
echo "" > $scr

#
IFS=$'\n'       # make newlines the only separator

if [ "$(yq -r ".tags.$tag.apk" $config)" != null ]
then
  #
  apk_libs=$(yq -r ".tags.$tag.apk | .[]" $config)

  for apk in $apk_libs
  do
      echo "apk add --no-cache $apk" >> $scr
  done
fi

if [ "$(yq -r ".tags.$tag.pip" $config)" != null ]
then
    ## run pip upgrade to avoid out-of-date message in build
    echo "pip install --upgrade pip" >> $scr

  #
  pip_libs=$(yq -r ".tags.$tag.pip | .[]" $config)

  for pip in $pip_libs
  do
      echo "pip install $pip" >> $scr
  done
fi
