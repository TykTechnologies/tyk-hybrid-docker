#!/bin/bash
echo "**************************************************************************************************************"
echo "*                                                                                                            *"
echo "** Use of the Tyk Hybrid Container is subject to the End User License Agreement located in /opt/tyk/EULA.md **"
echo "*                                                                                                            *"
echo "**************************************************************************************************************"
echo ""

sed -i 's/RPORT/'$RPORT'/g' /opt/tyk/tyk.conf
sed -i 's/PORT/'$PORT'/g' /opt/tyk/tyk.conf
sed -i 's/SECRET/'$SECRET'/g' /opt/tyk/tyk.conf
sed -i 's/ORGID/'$ORGID'/g' /opt/tyk/tyk.conf
sed -i 's/APIKEY/'$APIKEY'/g' /opt/tyk/tyk.conf
sed -i 's/REDISHOST/'$REDISHOST'/g' /opt/tyk/tyk.conf
sed -i 's/REDISPW/'$REDISPW'/g' /opt/tyk/tyk.conf


if [ -z "$DISABLENGINX" ]; then
	echo "--> NginX Disabled"
    service nginx start
fi

if [ -z "$BINDSLUG" ];
	then
    	sed -i 's/USESLUGS/'false'/g' /opt/tyk/tyk.conf
    else
    	echo "--> Binding to slugs instead of listen paths"
    	sed -i 's/USESLUGS/'true'/g' /opt/tyk/tyk.conf
fi

echo "--> Starting Tyk Hybrid"
echo ""
service redis-server start
cd /opt/tyk/
./tyk --conf=tyk.conf
