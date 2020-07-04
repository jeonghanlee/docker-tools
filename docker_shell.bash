#!/usr/bin/env bash

NAMESPACE="jeonghanlee"

function xDockerImagesDelete
{
    local images;
    images=$(docker images -a -q);
    docker rmi -f "$images"
}


function xDockerPruneAll
{
    docker system prune -a --volumes
}


function xDockerPrune
{
    docker system prune
}

function xDockerRun
{
    local REPOSITORY="$1"; shift; 
    local OPTS=( "$@" ); shift;

    if [ -z "${REPOSITORY}" ]; then
        printf "The first argument should be defined as REPOSITORY\\n";
    else    
        docker run --network=host "${OPTS[@]}" --rm --name="$REPOSITORY"  "$NAMESPACE"/"$REPOSITORY":latest
    fi
}

function xDockerPull
{
    local REPOSITORY="$1"; shift;
    docker pull "$NAMESPACE"/"$REPOSITORY"
}

function xDockerStop
{
    local name="$1"; shift;
    docker stop "$name"
}

function xDockerLogin
{
    local REPOSITORY="$1"; shift;
    docker run -i -t --entrypoint /bin/bash "$NAMESPACE"/"$REPOSITORY"   
}

function xDockerLogs
{
    local name="$1"; shift;
    docker logs "$name"
}

function xDockerInspect
{
    local REPOSITORY="$1"; shift;
    docker inspect "$NAMESPACE"/"$REPOSITORY"
}

function xDockerPs
{
    local OPTS=( "$@" ); shift;
    docker ps  "${OPTS[@]}"
}

## Very usefule to debug the error exit of building docker images. 
## the first argument is the last successful layer ID 
## the second argument is the options
function xDockerLastIdIn
{
    local last_image_id="$1"; shift;
    local OPTS=( "$@" ); shift;
    docker run -i -t  "${OPTS[@]}" "$last_image_id"
}

function xDockerEntrypointIn
{
    local last_image_id="$1"; shift;
    xDockerLastIdIn "$last_image_id" "--entrypoint" "/bin/sh"
}

# Credits
# https://stackoverflow.com/questions/32113330/check-if-imagetag-combination-already-exists-on-docker-hub
# https://stedolan.github.io/jq/manual/#Basicfilters
# xDockerTagExist "repository" "tag"
# xDockerTagExist "channelfinder" "v0.1.1" 
function xDockerTagExist
{
    local REPOSITORY="$1"; shift;
    local tag="$1"; shift; 
    curl -s https://hub.docker.com/v2/repositories/"$NAMESPACE"/"$REPOSITORY"/tags/"$tag" | jq -r '.["name"]? // .["message"]?'
}