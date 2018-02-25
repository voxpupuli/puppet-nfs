# Dockerfile used to build base image for projects using Python, Node, and Ruby.
FROM phusion/baseimage:0.9.16
MAINTAINER Daniel Klockenkaemper <dk@marketing-factory.de>

ARG RUBY_VERSION

RUN rm /bin/sh && ln -s /bin/bash /bin/sh && \
    sed -i 's/^mesg n$/tty -s \&\& mesg n/g' /root/.profile

WORKDIR /puppet

ENV PATH /usr/local/rvm/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH


# Install base system libraries.
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /etc/dpkg/dpkg.cfg.d/02apt-speedup


# Install rvm, default ruby version and bundler.
COPY .gemrc /puppetcode/.gemrc
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys D39DC0E3 && \
    curl -L https://get.rvm.io | /bin/bash -s stable && \
    echo 'source /etc/profile.d/rvm.sh' >> /etc/profile && \
    /bin/bash -l -c "rvm requirements;" && \
    rvm install $RUBY_VERSION && \
    /bin/bash -l -c "rvm use --default $RUBY_VERSION && \
    gem install bundler"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]
