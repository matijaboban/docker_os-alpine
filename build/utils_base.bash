#!/bin/bash

returnBashVersion ()
{
    echo ${BASH_VERSINFO[0]}

    # Emmit exit status. As the function is constructed for re-usablity
    # it needs to exited ptoperly. TODO desc
    exit 0
}

checkMinBashVersion ()
{
    # Check we're not running bash 3.x
    if [ $(returnBashVersion) -lt 7 ]; then
        echo "Bash 4.1 or later is required."
        exit 1
    fi

    exit 0
}




# bash --version | head -n 1 | grep version | awk -F ' ' '{print $4}'




## generate image name and tag
# generateImageNameAndTag ()
# {
#     # define defaults
#     image_name_prefix=''
#     image_name_base=$(yq -r '.docker.repoName' $config)
#     tag_base=null
#     correct_underscore=true

#     # process options localy defined TODO desc
#     local OPTIND b t g p u
#     while getopts b:t:g:p:u: option
#     do
#         case "${option}"
#         in
#             b) image_name_base=${OPTARG};;
#             p) image_name_prefix=${OPTARG};;
#             t) tag=${OPTARG};;
#             g) tag_base=${OPTARG};;
#             u) correct_underscore=${OPTARG};;
#         esac
#     done

#     # blank the tag name when core is used
#     # as when the core is used, its a bare tag
#     if [ $tag == 'core' ]
#     then
#         tag=''
#     fi


#     ## TODO desc
#     if [[ -z $tag_base || $tag_base == null ]]
#     then
#         image_name=$image_name_base
#     else
#         image_name=$image_name_base:$tag_base
#     fi


#     ## TODO desc
#     if [[ ! -z $tag && ! -z $tag_base ]]
#     then
#         image_name=$image_name-$tag
#     elif [[ ! -z $tag && -z $tag_base ]]
#     then
#         image_name=$image_name:$tag
#     fi


#     ## TODO desc
#     if [ ! -z $image_name_prefix ]
#     then
#         image_name=$image_name_prefix$image_name
#     fi

#     ## TODO desc convert underscore to hyphen due to jq issue with parsing
#     if [ $correct_underscore == true ]
#     then
#         image_name=${image_name//_/-}
#     fi


#     ## TODO desc
#     echo  "${image_name%-}"

#     # exit 0
# }

# loadDockerImageFromTar ()
# {
#     # define defaults
#     is_image_commpresed=true


#     # process options localy defined TODO desc
#     local OPTIND i p
#     while getopts i:p: option
#     do
#         case "${option}"
#         in
#             i) image_name=${OPTARG};;
#             p) image_base_path=${OPTARG};;
#         esac
#     done

#     ## Handle required parameters not set
#     ##
#     if [[ -z "$image_name" ||  -z "$image_base_path" ]]
#     then
#           echo "Required parameters not set."
#           exit 1
#     fi

#     ##
#     if [ $is_image_commpresed == true ]
#     then
#         printf ":: --> Decompressing $image_name image\n"
#         gzip -dk $image_base_path/${image_name//[\/]/_}.tar.gz
#     fi

#     ##
#     printf ":: --> Loading $image_name image\n"
#     docker load -i $image_base_path/${image_name//[\/]/_}.tar

#     # exit 0
# }

# ## tag docker image for remote repo
# tagDockerImage ()
# {
#     # define defaults
#     destination_base=matijaboban

#     # process options localy defined TODO desc
#     local OPTIND s d
#     while getopts s:d: option
#     do
#         case "${option}"
#         in
#             s) source_name=${OPTARG};;
#             d) destination_name=${OPTARG};;
#             b) destination_base=${OPTARG};;
#         esac
#     done

#     ## Handle required parameters not set
#     ##
#     if [[ -z "$source_name" ]]
#     then
#         echo "Required parameters not set."
#         exit 1
#     fi

#     # in case when the full remote name isnt specified
#     # we contruct the remote name/tag from local by
#     # replacing the "local" prefix with remote base
#     # brefix/path TODO
#     if [ -z "$destination_name" ]
#     then
#         destination_name=$destination_base/${source_name#*\/}
#     fi

#     ## return tag command
#     docker tag $source_name $destination_name

#     # Emmit exit status. As the function is constructed for re-usablity
#     # it needs to exited ptoperly
#     # exit 0
# }


# # publishDockerImage ()
# # {
# #     echo publishDockerImage
# #     exit 0
# # }

# ##
"$@"
