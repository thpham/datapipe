
Adminer:        http://localhost:8543
Druid Console:	http://localhost:8081
Druid Indexing: http://localhost:8090/console.html
Superset:       http://localhost:8088


protoc -o druid/descriptors/metrics.desc metrics.proto

protoc -o metrics.desc metrics.proto --python_out=.

curl -X POST -H 'Content-Type: application/json' -d @kafka-metrics-pb.json http://localhost:8081/druid/indexer/v1/supervisor

kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic metrics_pb
kafka-topics --list --zookeeper localhost:2181

./generate-example-metrics.py | ./pb_publisher.

kafka-console-consumer --bootstrap-server localhost:9092 --topic metrics_pb

---

curl -X POST -H 'Content-Type: application/json' -d @kafka-metrics.json http://localhost:8081/druid/indexer/v1/supervisor

kafka-topics --create --zookeeper localhost:2181 --replication-factor 1 --partitions 1 --topic metrics
kafka-topics --list --zookeeper localhost:2181

./generate-example-metrics.py | kafka-console-producer --broker-list localhost:9092 --topic metrics

kafka-console-consumer --bootstrap-server localhost:9092 --topic metrics
