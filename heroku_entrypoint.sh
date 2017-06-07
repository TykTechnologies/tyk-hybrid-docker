#!/bin/sh
REDIS_URL=`echo $REDIS_URL | sed -e s,redis://,,g`
userpass=`echo $REDIS_URL | grep @ | cut -d@ -f1`
hostport=`echo $REDIS_URL |  cut -d@ -f2`
REDISUSER=`echo $userpass | grep : | cut -d: -f1`
REDISPW=`echo $userpass | grep : | cut -d: -f2`
REDISHOST=`echo $hostport | grep : | cut -d: -f1`
REDISPORT=`echo $hostport | grep -oE "[^:]+$"`

sed -i 's/REDISHOST/'$REDISHOST'/g' tyk.conf
sed -i 's/REDISPORT/'$REDISPORT'/g' tyk.conf
sed -i 's/REDISUSER/'$REDISUSER'/g' tyk.conf
sed -i 's/REDISPW/'$REDISPW'/g' tyk.conf

sed -i 's/SECRET/'$SECRET'/g' tyk.conf
sed -i 's/ORGID/'$ORGID'/g' tyk.conf
sed -i 's/APIKEY/'$APIKEY'/g' tyk.conf

sed -i 's/PORT/'$PORT'/g' tyk.conf

if [ -z "$BINDSLUG" ];
        then
        sed -i 's/USESLUGS/'false'/g' tyk.conf
    else
        echo "--> Binding to slugs instead of listen paths"
        sed -i 's/USESLUGS/'true'/g' tyk.conf
fi

echo "-----> Starting Tyk"

cd tyk
./tyk --conf=../tyk.conf
