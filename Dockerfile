FROM debian:jessie-slim

ENV GRPCVERSION 1.7.0
ENV TYKVERSION 2.5.0
ENV TYKLANG ""

LABEL Description="Tyk Gateway docker image" Vendor="Tyk" Version=$TYKVERSION

RUN apt-get update \
 && apt-get upgrade -y \
 && apt-get install -y --no-install-recommends \
            wget curl ca-certificates apt-transport-https gnupg unzip \
 && curl -L https://packagecloud.io/tyk/tyk-gateway/gpgkey | apt-key add - \
 && apt-get install -y --no-install-recommends \
            build-essential \
            libluajit-5.1-2 \
            luarocks \
 && luarocks install lua-cjson \
 && apt-get install -y --no-install-recommends \
            python3-setuptools \
            libpython3.4 \
 && wget https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py && rm get-pip.py \
 && pip3 install grpcio==$GRPCVERSION \
 && apt-get purge -y build-essential \
 && apt-get autoremove -y \
 && rm -rf /root/.cache

RUN apt-get update \
 && apt-get install -y --no-install-recommends redis-server nginx

# The application RUN command is separated from the dependencies to enable app updates to use docker cache for the deps
RUN echo "deb https://packagecloud.io/tyk/tyk-gateway/debian/ jessie main" | tee /etc/apt/sources.list.d/tyk_tyk-gateway.list \
 && apt-get update \
 && apt-get install -y tyk-gateway=$TYKVERSION \
 && rm -rf /var/lib/apt/lists/*

RUN rm /etc/nginx/sites-enabled/default && rm /etc/nginx/sites-available/default

COPY nginx/1_upstream.conf /etc/nginx/conf.d/
COPY nginx/sample.tconf /etc/nginx/sites-enabled/ 
COPY tyk /opt/tyk-gateway
COPY EULA.md /opt/tyk-gateway/EULA.md
COPY entrypoint.sh /opt/tyk-gateway/entrypoint.sh

VOLUME ["/opt/tyk-gateway/", "/etc/nginx/sites-enabled/"]

RUN echo "** Use of the Tyk hybrid Container is subject to the End User License Agreement located in /opt/tyk-gateway/EULA.md **"

EXPOSE 8080 80 443

WORKDIR /opt/tyk-gateway/
ENTRYPOINT ["./entrypoint.sh"]

