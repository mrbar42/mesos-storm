#
# Dockerfile for Storm Mesos framework
#
FROM mesosphere/mesos:0.27.2-2.0.15.ubuntu1404
MAINTAINER Timothy Chen <tnachen@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

# export environment
ENV JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64

ENV MESOS_NATIVE_JAVA_LIBRARY /usr/lib/libmesos.so

ARG MESOS_RELEASE=0.27.2
ARG STORM_RELEASE=0.9.6
ARG MIRROR=http://www.gtlib.gatech.edu/pub

# install nodejs
RUN apt-get update && \
    apt-get install curl -y && \
    curl -sL https://deb.nodesource.com/setup_4.x | sudo -E bash - && \
    apt-get install -y python nodejs gcc-c++ make && \
    apt-get clean

ADD . /work

WORKDIR /work

RUN apt-get update && \
  apt-get install -y openjdk-7-jdk maven wget python && \
  ./bin/build-release.sh main && \
  mkdir -p /opt/storm && \
  tar xf storm-mesos-*.tgz -C /opt/storm --strip=1 && \
  rm -rf /work ~/.m2 && \
  apt-get -yf autoremove openjdk-7-jdk maven && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

WORKDIR /opt/storm
