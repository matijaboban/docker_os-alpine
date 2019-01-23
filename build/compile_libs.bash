#!/bin/bash

## config path
config=/tmp/workspace/config.yaml
scr=~/project/build/compiled/packages-install.sh


while getopts t: option
do
 case "${option}"
 in
 t) tag=${OPTARG};;
 esac
done

echo $tag

echo "" > $scr


IFS=$'\n'       # make newlines the only separator


if [ $(yq -r ".tags.$tag.apk" $config) != null ]
then
  #
  apk_libs=$(yq -r ".tags.$tag.apk | .[]" $config)

  for apk in $apk_libs
  do
      echo "apk add --no-cache $apk" >> $scr
  done
fi

if [ $(yq -r ".tags.$tag.pip" $config) != null ]
then
  #
  pip_libs=$(yq -r ".tags.$tag.pip | .[]" $config)

  for pip in $pip_libs
  do
      echo "pip install $pip" >> $scr
  done
fi
