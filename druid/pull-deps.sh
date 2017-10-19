#!/bin/bash
EXTENSIONS=( "$@" )
DRUID_HOME=/opt/druid/current

concat=""
list=$(echo $EXTENSIONS | tr "," "\n")
for extension in $list
do
  concat=$concat$(echo "-c $extension ")
done

java -cp "$DRUID_HOME/lib/*" \
  -Ddruid.extensions.directory="$DRUID_HOME/extensions" \
  -Ddruid.extensions.hadoopDependenciesDir="$DRUID_HOME/hadoop-dependencies" \
  io.druid.cli.Main tools pull-deps --no-default-hadoop --defaultVersion ${DRUID_VERSION} $concat

rm -rf ~/.m2/repository/*