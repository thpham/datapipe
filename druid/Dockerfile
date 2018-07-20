FROM openjdk:8-jdk-alpine

RUN apk --update --no-cache add ca-certificates tini curl tzdata bash

ENV DOCKERIZE_VERSION v0.5.0
RUN curl -jksSLO https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_VERSION}/dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz \
    && rm dockerize-linux-amd64-${DOCKERIZE_VERSION}.tar.gz

# make the "en_US.UTF-8" locale so this image will be utf-8 enabled by default
# alpine doesn't require explicit locale-file generation
ENV LANG en_US.utf8
ENV TIMEZONE Europe/Zurich
RUN rm /etc/localtime && \
    ln -s /usr/share/zoneinfo/$TIMEZONE /etc/localtime

ENV DRUID_HOME /opt/druid

# create group + user
RUN mkdir -p ${DRUID_HOME} && addgroup druid && adduser -G druid -g '' -h ${DRUID_HOME} -s /bin/bash -D druid

EXPOSE 8081 8082 8083 8084 8088 8090 8091 8100-8199

# Druid version
ARG DRUID_VERSION=0.12.1

# install druid
RUN cd /tmp \
    && curl -O http://static.druid.io/artifacts/releases/druid-${DRUID_VERSION}-bin.tar.gz \
    && tar xzf druid-${DRUID_VERSION}-bin.tar.gz \
    && mv druid-${DRUID_VERSION} ${DRUID_HOME} \
    && ln -s ${DRUID_HOME}/druid-${DRUID_VERSION} ${DRUID_HOME}/current

ENV DRUID_VERSION=${DRUID_VERSION}
ADD pull-deps.sh ${DRUID_HOME}/
# separate multiple deps with ','
RUN ${DRUID_HOME}/pull-deps.sh 'io.druid.extensions.contrib:scan-query'

RUN mkdir ${DRUID_HOME}/current/var \
    && chown -R druid: ${DRUID_HOME}/current/var

VOLUME ${DRUID_HOME}/current/var

ADD common.runtime.tmpl ${DRUID_HOME}/current/conf-quickstart/druid/_common
ADD entrypoint.sh ${DRUID_HOME}/entrypoint.sh
ADD descriptors/ /tmp/
RUN chmod +x ${DRUID_HOME}/entrypoint.sh \
    && chown druid: -R ${DRUID_HOME}

USER druid
WORKDIR ${DRUID_HOME}/current
ENTRYPOINT ["/sbin/tini", "--", "../entrypoint.sh"]
