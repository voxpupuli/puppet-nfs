# Dockerfile used to build base image for projects using Python, Node, and Ruby.
FROM ubuntu:latest 
MAINTAINER Daniel Klockenkaemper <dk@marketing-factory.de>

ARG RUBY_VERSION

WORKDIR /puppet/module

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

# Install base system libraries.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git ca-certificates gnupg2 dirmngr

# Install rvm, default ruby version and bundler.
COPY .gemrc /puppet/module/.gemrc

RUN gpg2 -v --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
RUN curl -L https://get.rvm.io | /bin/bash -s stable && \
    echo 'source /etc/profile.d/rvm.sh' >> /etc/profile && \
    /bin/bash -l -c "rvm requirements;" && \
    rvm install $RUBY_VERSION && \
    /bin/bash -l -c "rvm use --default $RUBY_VERSION && \
    gem install bundler"

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/dpkg/dpkg.cfg.d/02apt-speedup && \
    rm -rf /usr/local/rvm/archives/*

RUN sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile
