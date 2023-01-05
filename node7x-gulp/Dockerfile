FROM ubuntu:16.04

MAINTAINER Yogesh Linganna

WORKDIR /opt

ADD setup_7.x /tmp/setup_7.x
RUN bash /tmp/setup_7.x

RUN apt-get update
RUN apt-get install -y build-essential
RUN apt-get install -y nodejs
RUN apt-get install -y git

RUN /usr/bin/npm install -g gulp
RUN /usr/bin/npm install -g bower

VOLUME ["/opt"]
CMD ["gulp", "watch"]
