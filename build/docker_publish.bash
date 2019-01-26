#!/bin/bash

# set working dir
working_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

## import helpers
source $working_directory/helpers.bash


## default values
config=/tmp/workspace/config.yaml
docker_image_base_path=/tmp/workspace/docker
tag_base=null

while getopts c:g:p: option
do
    case "${option}"
    in
        c) config=${OPTARG};;
        g) tag_base=${OPTARG};;
        p) docker_image_base_path=${OPTARG};;
    esac
done


# Get docker tags from config
docker_tags=$(yq -r '.tags | map_values(keys) | to_entries[] | .key' $config)

for tag in $docker_tags
do
    docker_image_name=$(generateImageNameAndTag -t $tag -g $tag_base -p "local/")

    ## TEMP
    loadDockerImageFromTar -i $docker_image_name -p $docker_image_base_path

done
docker images
