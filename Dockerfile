FROM ubuntu:14.04
 
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN locale-gen en_US en_US.UTF-8
ENV LANG en_US.UTF-8

#Runit
RUN apt-get install -y runit 
CMD export > /etc/envvars && /usr/sbin/runsvdir-start
RUN echo 'export > /etc/envvars' >> /root/.bashrc

#Utilities
RUN apt-get install -y vim less net-tools inetutils-ping wget curl git telnet nmap socat dnsutils netcat tree htop unzip sudo software-properties-common
RUN apt-get install -y build-essential
RUN apt-get install -y nginx

#Node
RUN curl http://nodejs.org/dist/v0.10.35/node-v0.10.35-linux-x64.tar.gz | tar xz
RUN mv node* node && \
    ln -s /node/bin/node /usr/local/bin/node && \
    ln -s /node/bin/npm /usr/local/bin/npm
ENV NODE_PATH /usr/local/lib/node_modules

#Change last_commit hash as a cache buster
#ENV latest_commit e37ab66b36c1c5a5faa77a8e0f954454415a541c
RUN git clone --depth 1 https://github.com/anamer/core
RUN cd core && \
    ./scripts/install-sdk.sh

#ssl
RUN mkdir -p /etc/nginx/ssl && \
    cd /etc/nginx/ssl && \
    export PASSPHRASE=$(head -c 500 /dev/urandom | tr -dc a-z0-9A-Z | head -c 128; echo) && \
    openssl genrsa -des3 -out server.key -passout env:PASSPHRASE 2048 && \
    openssl req -new -batch -key server.key -out server.csr -subj "/C=/ST=/O=org/localityName=/commonName=org/organizationalUnitName=org/emailAddress=/" -passin env:PASSPHRASE && \
    openssl rsa -in server.key -out server.key -passin env:PASSPHRASE && \
    openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt

#Set your user:password
RUN echo "user:`perl -le 'print crypt(\"password\", \"salt-hash\")'`" > /etc/nginx/htpasswd
ADD default /etc/nginx/sites-enabled/default

#Add runit services
ADD sv /etc/service 

#install qemu
RUN apt-get install -y qemu-system-x86

# Add wruser user
RUN adduser --home /home/wruser --disabled-password --quiet -gecos ""  wruser 

# Creat directory Workspace
RUN mkdir /home/wruser/workspace

# Create tap device
#RUN mkdir -p /dev/net
#RUN mknod /dev/net/tun c 10 200
#RUN chmod 600 /dev/net/tun
#RUN cat /dev/net/tun



