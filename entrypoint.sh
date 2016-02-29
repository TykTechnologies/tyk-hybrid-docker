#!/bin/bash

sed -i 's/RPORT/'$RPORT'/g' /opt/tyk/tyk.conf
sed -i 's/PORT/'$PORT'/g' /opt/tyk/tyk.conf
sed -i 's/SECRET/'$SECRET'/g' /opt/tyk/tyk.conf
sed -i 's/ORGID/'$ORGID'/g' /opt/tyk/tyk.conf
sed -i 's/APIKEY/'$APIKEY'/g' /opt/tyk/tyk.conf
sed -i 's/REDISHOST/'$REDISHOST'/g' /opt/tyk/tyk.conf
sed -i 's/REDISPW/'$REDISPW'/g' /opt/tyk/tyk.conf

cd /opt/tyk/

service redis-server start
service nginx start

./tyk --conf=tyk.conf
