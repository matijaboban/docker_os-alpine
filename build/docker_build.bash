#!/bin/bash

# set working dir
working_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

## import helpers
source $working_directory/helpers.bash


## default values
config=/tmp/workspace/config.yaml
scr=~/project/build/compiled/packages-install.sh
log_dir=~/project/.logs
save_image=false
save_image_dir=/tmp/workspace/docker
compress_image=true
tag_base=null

while getopts c:s:t:i:p:l:g: option
do
    case "${option}"
    in
        c) config=${OPTARG};;
        s) scr=${OPTARG};;
        t) tag=${OPTARG};;
        i) save_image=${OPTARG};;
        p) save_image_dir=${OPTARG};;
        l) log_dir=${OPTARG};;
        g) tag_base=${OPTARG};;
    esac
done


# echo build

docker_tags=$(yq -r '.tags | map_values(keys) | to_entries[] | .key' $config)

## create workspace dir if saving docker images
if [ $save_image == true ]
then
    mkdir -p $save_image_dir
fi

for tag in $docker_tags
do
    docker_image_name=$(generateImageNameAndTag -t $tag -g $tag_base -p "local/")

    printf "\n:: Start build for $docker_image_name\n"

    # compile lib build commands
    bash $working_directory/compile_libs.bash -t $tag -c config.yaml -s $working_directory/compiled/packages-install.sh

    # build docker image and log
    docker build --force-rm -t $docker_image_name . | tee $log_dir/${docker_image_name//[\/]/_}.log

    ## save docekr images
    if [ $save_image == true ]
    then
        printf ":: --> Saving $docker_image_name image\n"
        docker save -o $save_image_dir/${docker_image_name//[\/]/_}.tar $docker_image_name

        ## compress image
        if [ $compress_image == true ]
        then
            printf ":: --> Compressing $docker_image_name image\n"
            gzip -9 $save_image_dir/${docker_image_name//[\/]/_}.tar
        fi
    fi

    ## TEMP
    loadDockerImageFromTar -i $docker_image_name -p $save_image_dir

done
docker images
