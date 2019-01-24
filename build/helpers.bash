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
