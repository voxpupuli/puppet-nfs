# Dockerfile used to build base image for projects using Python, Node, and Ruby.
FROM ubuntu:20.04
LABEL MAINTAINER "Daniel Klockenkaemper"

ARG RUBY_VERSION

WORKDIR /puppet/module

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH

# Install base system libraries.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git ca-certificates gnupg2 dirmngr

# Install rvm, default ruby version and bundler.
COPY .gemrc /puppet/module/.gemrc

RUN curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
RUN curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
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
