FROM ubuntu:14.04
RUN apt-get update && apt-get install -y ca-certificates
RUN apt-get install -y redis-server
RUN apt-get install -y nginx

RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default

COPY tyk /opt/tyk 
COPY nginx/1_upstream.conf /etc/nginx/conf.d/
COPY nginx/sample.tconf /etc/nginx/sites-enabled/ 
COPY entrypoint.sh /opt/tyk/entrypoint.sh
COPY EULA.md /opt/tyk/EULA.md

RUN chmod +x /opt/tyk/entrypoint.sh

VOLUME ["/opt/tyk/", "/etc/nginx/sites-enabled/"]

WORKDIR /opt/tyk

RUN echo "** Use of the Tyk hybrid Container is subject to the End User License Agreement located in /opt/tyk/EULA.md **"
CMD ["./entrypoint.sh"]
EXPOSE 8080 80 443