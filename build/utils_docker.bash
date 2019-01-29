#!/bin/bash


## generate image name and tag
generateImageNameAndTag ()
{
    # define defaults
    image_name_prefix=''
    image_name_base=''
    tag_base=null
    correct_underscore=true

    # process options localy defined TODO desc
    local OPTIND b t g p u
    while getopts b:t:g:p:u: option
    do
        case "${option}"
        in
            b) image_name_base=${OPTARG};;
            p) image_name_prefix=${OPTARG};;
            t) tag=${OPTARG};;
            g) tag_base=${OPTARG};;
            u) correct_underscore=${OPTARG};;
        esac
    done

    ## Handle required parameters not set
    ##
    if [[ -z "$image_name_base" ]]
    then
          echo "Required parameters not set."
          exit 1
    fi

    # blank the tag name when core is used
    # as when the core is used, its a bare tag
    if [[ $tag = 'core' ]]
    then
        tag=''
    fi


    ## TODO desc
    if [[ -z $tag_base || $tag_base == null ]]
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

    ## TODO desc convert underscore to hyphen due to jq issue with parsing
    if [ $correct_underscore == true ]
    then
        image_name=${image_name//_/-}
    fi


    ## TODO desc
    echo  "${image_name%-}"

    # Emmit exit status. As the function is constructed for re-usablity
    # it needs to exited ptoperly. TODO desc
    exit 0
}

## tag docker image for remote repo
tagDockerImage ()
{
    # define defaults
    destination_base=matijaboban
    destination_name=''

    # process options localy defined TODO desc
    local OPTIND s d
    while getopts s:d: option
    do
        case "${option}"
        in
            s) source_name=${OPTARG};;
            d) destination_name=${OPTARG};;
            b) destination_base=${OPTARG};;
        esac
    done

    ## Handle required parameters not set
    ##
    if [[ -z "$source_name" ]]
    then
        echo "Required parameters not set."
        exit 1
    fi

    # in case when the full remote name isnt specified
    # we contruct the remote name/tag from local by
    # replacing the "local" prefix with remote base
    # brefix/path TODO
    if [ -z "$destination_name" ]
    then
        destination_name=$destination_base/${source_name#*\/}
    fi

    ## return tag command
    docker tag $source_name $destination_name

    ##
    docker push $destination_name

    # Emmit exit status. As the function is constructed for re-usablity
    # it needs to exited ptoperly
    exit 0
}

getDockerImageID ()
{
    # process options localy defined TODO desc
    local OPTIND n t
    while getopts n:t: option
    do
        case "${option}"
        in
            n) image_name=${OPTARG};;
            t) image_tag=${OPTARG};;
        esac
    done

    ## Handle required parameters not set
    ##
    if [[ -z "$image_name" ||  -z "$image_tag" ]]
    then
          echo "Required parameters not set."
          exit 1
    fi

    ## extract image tag from image name, if tag isnt explicitly
    ## passed
    if [[ -z "$image_tag" ]]
    then
        IFS=':' read -r -a image_name_with_tag <<< "$image_name"
        image_name=${image_name_with_tag[0]}
        image_tag=${image_name_with_tag[1]}
    fi

    ## get docker image
    image_id=$(docker images | grep $image_name | grep $image_tag | awk '{ print $3 }')

    ## return null if no image id has been retreived
    if [ -z "$image_id" ]
    then
        echo null
        exit 0
    fi

    ## return Docke image
    echo $image_id

    exit 0
}


runDockerOneOffCommand ()
{
    # process options localy defined TODO desc
    local OPTIND c i
    while getopts c:i: option
    do
        case "${option}"
        in
            c) command=${OPTARG};;
            i) image_id=${OPTARG};;
        esac
    done

    ## Handle required parameters not set
    ##
    if [[ -z "$command" ||  -z "$image_id" ]]
    then
          echo "Required parameters not set."
          exit 1
    fi

    ## start docker from image
    docker_id=$(docker run -d $image_id)

    ## run command in docker image
    command_output=$(docker exec $docker_id $command)

    ## kill runnign docker
    docker kill $docker_id

    ## return null if command has no output
    if [ -z "$command_output" ]
    then
        echo null
        exit 0
    fi

    ## return command output
    echo $command_output

    exit 0
}

runDocker ()
{
    # process options localy defined TODO desc
    local OPTIND c i
    while getopts c:i: option
    do
        case "${option}"
        in
            i) image_id=${OPTARG};;
        esac
    done

    ## Handle required parameters not set
    ##
    if [[ -z "$image_id" ]]
    then
          echo "Required parameters not set."
          exit 1
    fi

    ## start docker from image
    docker_id=$(docker run -d $image_id)

    ## return null if docker_id has no output
    if [ -z "$docker_id" ]
    then
        echo null
        exit 0
    fi

    ## return docker id
    echo $docker_id

    exit 0
}


killDocker ()
{
    # process options localy defined TODO desc
    local OPTIND c i
    while getopts c:i: option
    do
        case "${option}"
        in
            i) docker_id=${OPTARG};;
        esac
    done

    ## Handle required parameters not set
    ##
    if [[ -z "$docker_id" ]]
    then
          echo "Required parameters not set."
          exit 1
    fi

    ## start docker from image
    docker_id=$(docker kill $docker_id)

    ## return null if docker_id has no output
    if [ -z "$docker_id" ]
    then
        echo null
        exit 0
    fi

    ## return docker id
    echo $docker_id

    exit 0
}

#
"$@"
