FROM debian:7
ENV container docker
RUN echo "deb http://archive.debian.org/debian/ wheezy main contrib non-free" > /etc/apt/sources.list
RUN apt-get update
RUN apt-get install -y openssh-server openssh-client curl ntpdate lsb-release cron locales-all net-tools wget
RUN mkdir -p /var/run/sshd
RUN echo root:root | chpasswd
RUN sed -ri 's/^#?PermitRootLogin .*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
RUN sed -ri 's/^#?UseDNS .*/UseDNS no/' /etc/ssh/sshd_config
RUN echo "MaxAuthTries 100" >> /etc/ssh/sshd_config
EXPOSE 22
CMD ["/sbin/init"]