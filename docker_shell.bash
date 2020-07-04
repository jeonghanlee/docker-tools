#!/usr/bin/env bash

USERNAME="jeonghanlee"

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
    local name="$1"; shift;
    local OPTS=( "$@" ); shift;

    if [ -z "${name}" ]; then
        printf "The first argument should be defined as name\\n";
    else    
        docker run --network=host "${OPTS[@]}" --rm --name="$name"  "$USERNAME"/"$name":latest
    fi
}

function xDockerPull
{
    local name="$1"; shift;
    docker pull "$USERNAME"/"$name"
}

function xDockerStop
{
    local name="$1"; shift;
    docker stop "$name"
}

function xDockerLogin
{
    local name="$1"; shift;
    docker run -i -t --entrypoint /bin/bash "$USERNAME"/"$name"   
}

function xDockerLogs
{
    local name="$1"; shift;
    docker logs "$name"
}

function xDockerInspect
{
    local name="$1"; shift;
    docker inspect "$USERNAME"/"$name"
}

function xDockerPs
{
    local OPTS=( "$@" ); shift;
    docker ps  "${OPTS[@]}"
}