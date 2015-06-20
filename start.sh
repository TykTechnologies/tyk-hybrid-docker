#!/bin/bash

PORT=$1
SECRET=$2
ORGID=$3
APIKEY=$4

sudo docker stop tyk_hybrid && docker rm tyk_hybrid

sudo docker pull tykio/tyk-hybrid-docker

docker run -d --name tyk_hybrid -p $PORT:$PORT -e PORT=$PORT -e SECRET=$SECRET -e ORGID=$ORGID -e APIKEY=$APIKEY tykio/tyk-hybrid-docker
