FROM ubuntu
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN apt-get install -y redis-server
RUN apt-get install -y nginx

RUN rm /etc/nginx/sites-enabled/default
RUN rm /etc/nginx/sites-available/default

COPY tyk /opt/tyk 
COPY nginx/1_upstream.conf /etc/nginx/conf.d/
COPY nginx/sample.tconf /etc/nginx/sites-enabled/ 
COPY entrypoint.sh /opt/tyk/entrypoint.sh

RUN chmod +x /opt/tyk/entrypoint.sh

VOLUME ["/opt/tyk/", "/etc/nginx/sites-enabled/"]

WORKDIR /opt/tyk

CMD ["./entrypoint.sh"]
EXPOSE 8080 80 443