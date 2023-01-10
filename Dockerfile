FROM ubuntu:18.04
MAINTAINER threatstream

RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update && apt-get upgrade -y && apt-get install git wget gcc supervisor expect psmisc lsb-release -y
RUN mkdir -p /opt/hound /data/db /var/log/hound /var/log/supervisor

ADD ./ /opt/hound/
ADD scripts/docker_supervisord-hound.conf /etc/supervisor/conf.d/hound.conf
ADD scripts/docker_entrypoint.sh /entrypoint.sh

RUN chmod a+x /entrypoint.sh /opt/hound/scripts/docker_expect.sh /opt/hound/install.sh
RUN echo supervisorctl start mongod >> /opt/hound/scripts/install_mongo.sh

ENV SUPERUSER_EMAIL "root@localhost"
ENV SUPERUSER_PASSWORD "password"
ENV SERVER_BASE_URL "http://localhost:80"
ENV HONEYMAP_URL "http://localhost:3000"
ENV DEBUG_MODE "n"
ENV SMTP_HOST "localhost"
ENV SMTP_PORT "25"
ENV SMTP_TLS "n"
ENV SMTP_SSL "n"
ENV SMTP_USERNAME ""
ENV SMTP_PASSWORD ""
ENV SMTP_SENDER ""
ENV hound_LOG "/var/log/hound/hound.log"

EXPOSE 80
EXPOSE 10000
EXPOSE 3000
EXPOSE 8089

CMD ["/entrypoint.sh"]
