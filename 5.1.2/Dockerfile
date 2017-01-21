# MAINTAINER @willfarrell
FROM library/alpine:3.5

ENV FILEBEAT_VERSION=5.1.2 \
    FILEBEAT_SHA1=0b0a44bc0daf2c597dd3ee2b32120fc487f7472d

RUN set -x && \
  apk add --no-cache --virtual .build-deps ca-certificates wget \
  && wget https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-${FILEBEAT_VERSION}-linux-x86_64.tar.gz -O /tmp/filebeat.tar.gz \
  && cd /tmp \
  && ls \
  && echo "${FILEBEAT_SHA1}  filebeat.tar.gz" | sha1sum -c - \
  && tar xzvf filebeat.tar.gz \
  && cd filebeat-* \
  && cp filebeat /bin \
  #&& cp filebeat.yml /filebeat.yml \
  && cd /tmp \
  && rm -rf filebeat* \
  && apk del .build-deps \
  && apk add --no-cache --virtual .run-deps bash

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD [ "filebeat", "-e" ]
