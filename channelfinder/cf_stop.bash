#!/usr/bin/env bash

function stop_docker
{
    local name="$1"; shift;
    printf ">>> Stopping %s\\n" "$name";
    container_id=$(docker ps -q --filter="NAME=$name")
    if [ -z ${container_id+x} ]; then
	printf "no docker with %s\\n" "$name";
    else
	docker stop "$name";
	printf "... done\\n";
    fi
	
}

stop_docker "recsync"
stop_docker "channelfinder"
stop_docker "es4epics"

