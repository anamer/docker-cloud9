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
ENV latest_commit be54b38a9c
RUN git clone --depth 1 https://github.com/c9/core.git
RUN cd core && \
    ./scripts/install-sdk.sh

RUN echo "user:`perl -le 'print crypt(\"password\", \"salt-hash\")'`" > /etc/nginx/htpasswd
ADD default /etc/nginx/sites-enabled/default

#Add runit services
ADD sv /etc/service 

