#!/usr/bin/env bash

curl -v -X POST -H "Content-Type: application/json" -H "Accept: application/json" "http://localhost:8083/connectors" \
-d @- << EOF
{
  "name": "zanzito-location",
  "config": {
    "connector.class": "io.confluent.connect.mqtt.MqttSourceConnector",
    "tasks.max": "3",
    "value.converter": "org.apache.kafka.connect.converters.ByteArrayConverter",
    "config.action.reload": "RESTART",
    "errors.retry.timeout": "0",
    "errors.retry.delay.max.ms": "60000",
    "errors.tolerance": "none",
    "errors.log.enable": "false",
    "errors.log.include.messages": "false",
    "mqtt.server.uri": "tcp://mosquitto:1883",
    "mqtt.clean.session.enabled": "true",
    "mqtt.connect.timeout.seconds": "30",
    "mqtt.keepalive.interval.seconds": "60",
    "mqtt.password": "[hidden]",
    "kafka.topic": "mqtt.zanzito.device.location",
    "mqtt.topics": "zanzito/+/location",
    "mqtt.qos": "0"
  }
}
EOF

curl -v -X POST -H "Content-Type: application/json" -H "Accept: application/json" "http://localhost:8083/connectors" \
-d @- << EOF
{
  "name": "postgres",
  "config": {
    "connector.class": "io.confluent.connect.jdbc.JdbcSinkConnector",
    "connection.url": "jdbc:postgresql://postgres/dev",
    "connection.user": "postgres",
    "connection.password": "postgres",
    "dialect.name": "PostgreSqlDatabaseDialect",
    "topics": "things.location",
    "tasks.max": "3",
    "config.action.reload": "RESTART",
    "errors.retry.timeout": "0",
    "errors.retry.delay.max.ms": "60000",
    "errors.tolerance": "none",
    "errors.log.enable": "false",
    "errors.log.include.messages": "false",
    "errors.deadletterqueue.topic.replication.factor": "3",
    "errors.deadletterqueue.context.headers.enable": "false",
    "insert.mode": "upsert",
    "batch.size": "3000",
    "table.name.format": "${topic}",
    "pk.mode": "none",
    "auto.create": "true",
    "auto.evolve": "true",
    "max.retries": "10",
    "retry.backoff.ms": "3000"
  }
}
EOF