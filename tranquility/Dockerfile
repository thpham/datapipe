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

ENV TRANQUILITY_HOME /opt/tranquility

# create group + user
RUN mkdir -p ${TRANQUILITY_HOME} && addgroup tranquility && adduser -G tranquility -g '' -h ${TRANQUILITY_HOME} -s /bin/bash -D tranquility

EXPOSE 8200

# Tranquility version
ARG TRANQUILITY_VERSION=0.8.2
# install druid
RUN curl -L http://static.druid.io/tranquility/releases/tranquility-distribution-${TRANQUILITY_VERSION}.tgz | tar -xzf - -C /opt && \
    mv /opt/tranquility-distribution-${TRANQUILITY_VERSION} ${TRANQUILITY_HOME}/current


VOLUME ${TRANQUILITY_HOME}/current/conf

ADD server.json ${TRANQUILITY_HOME}/current/conf/server.json
RUN chown tranquility: -R ${TRANQUILITY_HOME}

USER tranquility
WORKDIR ${TRANQUILITY_HOME}/current
ENTRYPOINT ["/sbin/tini", "--", "bin/tranquility"]
#CMD ["--help"]
CMD ["server", "-configFile", "conf/server.json"]