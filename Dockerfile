FROM tknerr/baseimage-ubuntu:16.04
MAINTAINER "myself"

ARG GOVERSION=${GOVERSION:-1.8.1}
ENV GOVERSION=1.8.1
ARG ARCH="$(uname -m | sed 's|i686|386|' | sed 's|x86_64|amd64|')"
ENV ARCH="amd64"
ENV SRCROOT="/opt/go"
ENV SRCPATH="/opt/gopath"
ARG SRCROOT="/opt/go"
ARG SRCPATH="/opt/gopath"
ENV VOLPATH="/opt/gopath/src/github.com/hashicorp/terraform"

RUN echo 'APT::Install-Recommends 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && echo 'APT::Install-Suggests 0;' >> /etc/apt/apt.conf.d/01norecommends \
 && apt-get update \
 && apt-get upgrade -y\
 && DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential curl git-core libpcre3-dev mercurial pkg-config zip \
 && rm -rf /var/lib/apt/lists/*

RUN wget -P /tmp "https://storage.googleapis.com/golang/go${GOVERSION}.linux-${ARCH}.tar.gz"
RUN tar -C /opt -xf "/tmp/go${GOVERSION}.linux-${ARCH}.tar.gz"

RUN echo "\n"\
export GOPATH="$SRCPATH\n"\
export GOROOT="$SRCROOT\n"\
export PATH="$SRCROOT/bin:$SRCPATH/bin:\$PATH\n" >> ~/.bashrc

RUN chmod 755 ~/.bashrc

WORKDIR $VOLPATH/
VOLUME ["${VOLPATH}"]
