#!/bin/bash

## generate image name and tag
image_name ()
{
    # define defaults
    image_name_prefix=''
    image_name_base=$(yq -r '.docker.repoName' $config)
    tag_base=''

    # process options localy defined TODO desc
    local OPTIND b t
    while getopts b:t:g:p: option
    do
        case "${option}"
        in
            b) image_name_base=${OPTARG};;
            p) image_name_prefix=${OPTARG};;
            t) tag=${OPTARG};;
            g) tag_base=${OPTARG};;
        esac
    done

    # blank the tag name when core is used
    # as when the core is used, its a bare tag
    if [ $tag == 'core' ]
    then
        tag=''
    fi


    ## TODO desc
    if [ -z $tag_base ]
    then
        image_name=$image_name_base
    else
        image_name=$image_name_base:$tag_base
    fi


    ## TODO desc
    if [[ ! -z $tag && ! -z $tag_base ]]
    then
        image_name=$image_name-$tag
    elif [[ ! -z $tag && -z $tag_base ]]
    then
        image_name=$image_name:$tag
    fi


    ## TODO desc
    if [ ! -z $image_name_prefix ]
    then
        image_name=$image_name_prefix$image_name
    fi

    ## TODO desc
    echo  "${image_name%-}"
}

## default values
config=/tmp/workspace/config.yaml
scr=~/project/build/compiled/packages-install.sh
working_directory=$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )


while getopts c:s:t: option
do
    case "${option}"
    in
        c) config=${OPTARG};;
        s) scr=${OPTARG};;
        t) tag=${OPTARG};;
    esac
done


# echo build

docker_tags=$(yq -r '.tags | map_values(keys) | to_entries[] | .key' $config)


for tag in $docker_tags
do
    docker_image_name=$(image_name -t $tag -g 3.8 -p "local/")

    # compile lib build commands
    bash $working_directory/compile_libs.bash -t $tag -s $working_directory/compiled/packages-install.sh

    # build docker image and log
    echo docker build --force-rm -t $docker_image_name . | tee ${docker_image_name/\//}.log

done

