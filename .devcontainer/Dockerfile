FROM mcr.microsoft.com/vscode/devcontainers/ruby:3

ENV DEBIAN_FRONTEND=noninteractive
RUN curl -L https://apt.puppet.com/puppet-tools-release-focal.deb -o /tmp/puppet-tools-release-focal.deb && \
    sudo dpkg -i /tmp/puppet-tools-release-focal.deb && \
    sudo apt-get update && \
    sudo apt-get install pdk