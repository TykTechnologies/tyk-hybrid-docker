#!/bin/bash

sed -i 's/PORT/'$PORT'/g' /opt/tyk/tyk.conf
sed -i 's/SECRET/'$SECRET'/g' /opt/tyk/tyk.conf
sed -i 's/ORGID/'$ORGID'/g' /opt/tyk/tyk.conf
sed -i 's/APIKEY/'$APIKEY'/g' /opt/tyk/tyk.conf
cd /opt/tyk/

./tyk --conf=tyk.conf