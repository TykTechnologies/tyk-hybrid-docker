#!/bin/bash
: ${TYKDIR:="/opt/tyk"}

echo "**************************************************************************************************************"
echo "*                                                                                                            *"
echo "** Use of the Tyk Hybrid Container is subject to the End User License Agreement located in $TYKDIR/EULA.md **"
echo "*                                                                                                            *"
echo "**************************************************************************************************************"
echo ""

if [ -n "$REDIS_URL" ]; then
    REDIS_URL=`echo $REDIS_URL | sed -e s,redis://,,g`
    userpass=`echo $REDIS_URL | grep @ | cut -d@ -f1`
    hostport=`echo $REDIS_URL |  cut -d@ -f2`
    REDISUSER=`echo $userpass | grep : | cut -d: -f1`
    REDISPW=`echo $userpass | grep : | cut -d: -f2`
    REDISHOST=`echo $hostport | grep : | cut -d: -f1`
    RPORT=`echo $hostport | grep -oE "[^:]+$"`
fi

sed -i 's/TYKDIR/'$TYKDIR'/g' $TYKDIR/tyk.conf
sed -i 's/RPORT/'$RPORT'/g' $TYKDIR/tyk.conf
sed -i 's/PORT/'$PORT'/g' $TYKDIR/tyk.conf
sed -i 's/SECRET/'$SECRET'/g' $TYKDIR/tyk.conf
sed -i 's/ORGID/'$ORGID'/g' $TYKDIR/tyk.conf
sed -i 's/APIKEY/'$APIKEY'/g' $TYKDIR/tyk.conf
sed -i 's/REDISHOST/'$REDISHOST'/g' $TYKDIR/tyk.conf
sed -i 's/REDISUSER/'$REDISUSER'/g' $TYKDIR/tyk.conf
sed -i 's/REDISPW/'$REDISPW'/g' $TYKDIR/tyk.conf


if [ -z "$DISABLENGINX" ]; then
    echo "--> NginX enabled"
    service nginx start
fi

if [ -z "$BINDSLUG" ]; then
    sed -i 's/USESLUGS/'false'/g' $TYKDIR/tyk.conf
else
    echo "--> Binding to slugs instead of listen paths"
    sed -i 's/USESLUGS/'true'/g' $TYKDIR/tyk.conf
fi

if [ -z "$DISABLEREDIS" ]; then
    echo "->> Redis enabled"
    service redis-server start
fi

echo "--> Starting Tyk Hybrid"
echo ""
cd $TYKDIR
./tyk$TYKVERSION --conf=tyk.conf

