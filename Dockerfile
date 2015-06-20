FROM ubuntu
RUN apt-get install -y ca-certificates
RUN apt-get install -y redis

COPY tyk /opt/tyk 
COPY entrypoint.sh /opt/tyk/entrypoint.sh

RUN chmod +x /opt/tyk/entrypoint.sh

VOLUME ["/opt/tyk/"]
WORKDIR /opt/tyk

CMD ["./entrypoint.sh"]
EXPOSE 8080