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

# Druid version
ARG SPARK_VERSION=2.2.2
ARG HADOOP_VERSION=2.7.7

# Get Hadoop from EU Apache mirror and extract just the native
# libs. (Until we care about running HDFS with these containers, this
# is all we need.)
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://www.eu.apache.org/dist/hadoop/common/hadoop-${HADOOP_VERSION}/hadoop-${HADOOP_VERSION}.tar.gz | \
        tar -zx hadoop-${HADOOP_VERSION}/lib/native && \
    ln -s hadoop-${HADOOP_VERSION} hadoop && \
    echo Hadoop ${HADOOP_VERSION} native libraries installed in /opt/hadoop/lib/native

# Get Spark from EU Apache mirror.
RUN mkdir -p /opt && \
    cd /opt && \
    curl http://www.eu.apache.org/dist/spark/spark-${SPARK_VERSION}/spark-${SPARK_VERSION}-bin-hadoop2.7.tgz | \
        tar -zx && \
    ln -s spark-${SPARK_VERSION}-bin-hadoop2.7 spark && \
    echo Spark ${SPARK_VERSION} installed in /opt

# Add the GCS connector.
RUN cd /opt/spark/jars && \
    curl -O https://storage.googleapis.com/hadoop-lib/gcs/gcs-connector-latest-hadoop2.jar


RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools && \
    if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
    if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
    rm -r /root/.cache


# Python Machine Learning tools
RUN apk add --no-cache libstdc++ lapack-dev && \
    apk add --no-cache \
        --virtual=.build-dependencies \
        g++ gfortran musl-dev \
        python3-dev && \
    ln -s locale.h /usr/include/xlocale.h && \
    pip install numpy && \
    pip install pandas && \
    pip install scipy && \
    pip install scikit-learn && \
    find /usr/lib/python3.*/ -name 'tests' -exec rm -r '{}' + && \
    rm /usr/include/xlocale.h && \
    rm -r /root/.cache && \
    apk del .build-dependencies

# if numpy is installed on a driver it needs to be installed on all
# workers, so install it everywhere
#RUN apk --update --no-cache add python python-dev py-pip build-base py-numpy

EXPOSE 4040 6066 7001-7006 7012-7016 7077 8080 8081 8881

COPY entrypoint.sh  /usr/local/bin/
ADD log4j.properties /opt/spark/conf/log4j.properties
ADD start-common.sh /
ADD core-site.xml /opt/spark/conf/core-site.xml
ADD spark-defaults.conf.tmpl /opt/spark/conf/spark-defaults.conf
ENV PATH $PATH:/opt/spark/bin

ENTRYPOINT ["entrypoint.sh"]
