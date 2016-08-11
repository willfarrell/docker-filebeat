FROM debian:jessie

MAINTAINER will Farrell <will.farrell@gmail.com>

ENV FILEBEAT_VERSION=5.0.0-alpha5 \
    FILEBEAT_SHA1=f209553305c042872647327bbb4f3b7bb8dd4ca7

RUN set -x && \
  apt-get update && \
  apt-get install -y wget && \
  wget https://download.elastic.co/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /opt/filebeat.tar.gz && \
  cd /opt && \
  echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - && \
  tar xzvf filebeat.tar.gz && \
  cd filebeat-* && \
  cp filebeat /bin && \
  cp filebeat.yml /filebeat.yml && \
  cd /opt && \
  rm -rf filebeat* && \
  apt-get purge -y wget && \
  apt-get autoremove -y && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]
