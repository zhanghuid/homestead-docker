FROM ubuntu:16.04
MAINTAINER "https://github.com/shincoder"

ENV DEBIAN_FRONTEND noninteractive

# Install packages
ADD provision.sh /provision.sh
ADD serve.sh /serve.sh
ADD custom.sh /custom.sh

ADD supervisor.conf /etc/supervisor/conf.d/supervisor.conf

RUN chmod +x /*.sh

RUN ./provision.sh

RUN ./custom.sh

EXPOSE 80 22 35729 9876 3000
CMD ["/usr/bin/supervisord"]
