# Data pipeline POC

more to come ...

## Troubleshouting

if the schema-registry fails to start, then execute:

```shell
docker-compose exec kafka /bin/bash
kafka-topics --alter --config cleanup.policy=compact --topic _schemas --zookeeper zk
docker-compose restart schema-registry
```