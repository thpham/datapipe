FROM confluentinc/cp-kafka-connect:5.1.0
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components"

ADD https://s3.amazonaws.com/redshift-downloads/drivers/jdbc/1.2.16.1027/RedshiftJDBC42-1.2.16.1027.jar /usr/share/java/kafka-connect-jdbc/
# COPY sink-redshift.properties /etc/kafka-connect-jdbc/

RUN confluent-hub install --no-prompt thomaskwscott/kafka-connect-http:1.0.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-mqtt:1.0.0-preview
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-influxdb:1.0.0-preview
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:1.0.2
RUN confluent-hub install --no-prompt hpgrahsl/kafka-connect-mongodb:1.2.0
RUN confluent-hub install --no-prompt debezium/debezium-connector-mongodb:0.8.3
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:0.8.3

RUN confluent-hub install --no-prompt wepay/kafka-connect-bigquery:1.1.0
# copy BigQuery service account JSON key file

#RUN confluent-hub install --no-prompt imply/druid-kafka-indexing-service:2.6.1
