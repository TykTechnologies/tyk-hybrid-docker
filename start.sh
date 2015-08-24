#!/bin/bash
USAGE="--> Usage: ./start.sh PORT SECRET ORGID APIKEY (REDIS HOST) (REDIS PORT)"

if [ -z "$1" ]
then
        echo "Please specify a listen port for Tyk"
        echo $USAGE
        exit
fi

if [ -z "$2" ]
then
        echo "Please specify a Tyk Secret (REST API)"
        echo $USAGE
        exit
fi

if [ -z "$3" ]
then
        echo "Please specify an Organisation ID"
        echo $USAGE
        exit
fi

if [ -z "$4" ]
then
        echo "Please specify an API Key"
        echo $USAGE
        exit
fi

REDIS=$5
if [ -z "$5" ]
then
        echo "Using Redis localhost"
        REDIS=localhost
fi

RPORT=$6
if [ -z "$6" ]
then
        echo "Using Redis default port"
        RPORT=6379
fi

PORT=$1
SECRET=$2
ORGID=$3
APIKEY=$4

cwd=$(pwd)
mkdir confs
sudo docker stop tyk_hybrid && docker rm tyk_hybrid

sudo docker pull tykio/tyk-hybrid-docker

docker run -v $cwd/confs:/etc/nginx/sites-enabled -d --name tyk_hybrid -p $PORT:$PORT -p 80:80 -e PORT=$PORT -e SECRET=$SECRET -e ORGID=$ORGID -e APIKEY=$APIKEY -e REDIS=$REDIS -e RPORT=$RPORT tykio/tyk-hybrid-docker

echo "Tyk Hybrid Node Running"
echo "- To set up domains, place nginx server configs into the confs/ folder and restart"
echo "- To test the node, use port $PORT"