#!/bin/bash

function start-master () {
  . /start-common.sh
  echo "$(hostname -i) spark-master" >> /etc/hosts
  # Run spark-class directly so that when it exits (or crashes), the pod restarts.
  exec /opt/spark/bin/spark-class org.apache.spark.deploy.master.Master --ip spark-master --port 7077 --webui-port 8080
}

function start-worker () {
  . /start-common.sh
  if ! getent hosts spark-master; then
    echo "=== Cannot resolve the DNS entry for spark-master. Has the service been created yet, and is SkyDNS functional?"
    echo "=== See http://kubernetes.io/v1.1/docs/admin/dns.html for more details on DNS integration."
    echo "=== Sleeping 10s before pod exit."
    sleep 10
    exit 0
  fi
  # Run spark-class directly so that when it exits (or crashes), the pod restarts.
  exec /opt/spark/bin/spark-class org.apache.spark.deploy.worker.Worker spark://spark-master:7077 --webui-port 8081
}



case "$1" in
    "master")
      echo "Start spark-master"
      start-master
      ;;
    "worker")
      echo "Start spark-worker"
      start-worker
      ;;
    *)
      echo "Start spark-worker"
      start-worker
      ;;
esac