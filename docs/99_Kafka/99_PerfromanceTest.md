# Kafka Performance Test

## Single producer publishing 1000 byte messages with no replication
Create kafka topic
```shell
bin/kafka-topics.sh --zookeeper zookeeper.kafka:2181 --create --topic test --partitions 48 --replication-factor 1
```
Run the producer to publish events to Kafka topic
```shell
./bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic test --num-records 50000000 --record-size 100 --throughput -1 --producer-props acks=1 bootstrap.servers=212.47.241.204:32400 buffer.memory=104857600 batch.size=9000
```

## Single producer publishing 500 byte messages with (3x) and with out replication
> The objective of this test is to understand the cost of the replication

create kafka topic (with replication)
```shell
bin/kafka-topics.sh --zookeeper habench001:2181 --create --topic testr3 --partitions 48 --replication-factor 3
```
publish messages to kafka topic with required settings
```shell
bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic testr3 --num-records 30000000 --record-size 500 --throughput -1 --producer-props acks=1 bootstrap.servers=habench101:9092 buffer.memory=104857600 batch.size=6000
```

# Three producers, 3x async replication with different message sizes
> The object of the test is to understand the effect of the message size on the producer throughput

publish 200 byte messages to kafka topic
```shell
bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic testr3 --num-records 30000000 --record-size 200 --throughput -1 --producer-props acks=1 bootstrap.servers=habench101:9092 buffer.memory=104857600 batch.size=6000
``

publish 500 byte messages to kafka topic
```shell
bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic testr3 --num-records 15000000 --record-size 500 --throughput -1 --producer-props acks=1 bootstrap.servers=habench101:9092 buffer.memory=104857600 batch.size=6000
```

publish 1000 byte messages to kafka topic
```shell
bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic testr3 --num-records 10000000 --record-size 1000 --throughput -1 --producer-props acks=1 bootstrap.servers=habench101:9092 buffer.memory=104857600 batch.size=6000
```
