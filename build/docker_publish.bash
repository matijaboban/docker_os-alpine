#!/bin/bash

# set working dir
wdir=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )

## import helpers
source $wdir/helpers.bash


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

##
image_name_base=$(yq -r ".docker.repoName" $config)

# Get docker tags from config
docker_tags=$(yq -r '.tags | map_values(keys) | to_entries[] | .key' $config)
# echo $docker_tags; exit 0;
for tag in $docker_tags
do
    # docker_image_name=$(generateImageNameAndTag -t $tag -g $tag_base -p "local/")
    docker_image_name="$(bash $wdir/utils_docker.bash generateImageNameAndTag -b $image_name_base -t $tag -g $tag_base -p local/)"

    ## TEMP
    loadDockerImageFromTar -i $docker_image_name -p $docker_image_base_path

    ## temp tag
    bash $wdir/utils_docker.bash tagDockerImage -s $docker_image_name

    ## temp test
    bash $wdir/utils_docker.bash runDockerOneOffCommand -i $(bash $wdir/utils_docker.bash getDockerImageID -n $docker_image_name) -c "cat /etc/os-release"
done

    docker images
    docker ps

# bash utils_base.bash getDockerImageID -n "local/os-alpine" -t s3.8-rust
