FROM ubuntu:14.04
RUN apt-get update && apt-get install -y ca-certificates
RUN apt-get install -y redis-server
RUN apt-get install -y nginx
RUN apt-get install -y wget
RUN apt-get install -y build-essential
RUN apt-get install -y libluajit-5.1-2
RUN apt-get install -y luarocks
RUN luarocks install lua-cjson

RUN wget https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-python-3.1.0.tar.gz
RUN tar -xvzf protobuf-python-3.1.0.tar.gz
RUN cd protobuf-3.1.0/ &&  ./configure -prefix=/usr && make && make install

RUN apt-get install -y python3-setuptools
RUN apt-get install -y python3-dev
RUN cd protobuf-3.1.0/python && python3 setup.py build --cpp_implementation && python3 setup.py install --cpp_implementation
RUN apt-get install -y libpython3.4
RUN apt-get install -y python3-pip

# Sphinx 1.5.2 is broken
RUN pip3 install Sphinx==1.5.1
RUN pip3 install grpcio

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


