#!/usr/bin/env bash


docker pull jeonghanlee/es4epics
docker pull jeonghanlee/channelfinder
docker pull jeonghanlee/recsync

docker run -d --rm -p 9200:9200 --name=es4epics jeonghanlee/es4epics
sleep 5

docker run -d --rm --network=host --name=channelfinder jeonghanlee/channelfinder
sleep 5

docker run -d --rm --network=host --name=recsync jeonghanlee/recsync
sleep 3

docker ps
