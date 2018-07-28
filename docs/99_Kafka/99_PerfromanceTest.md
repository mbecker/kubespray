# Kafka Performance Test

> [Producer Configs](https://kafka.apache.org/documentation.html#producerconfigs)

## Single producer publishing 1000 byte messages with no replication
Create kafka topic
```shell
bin/kafka-topics.sh --zookeeper zookeeper.kafka:2181 --create --topic test-no-rep --partitions 48 --replication-factor 1

[2018-07-27 06:43:35,344] INFO Topic creation {"version":1,"partitions":{"45":[1],"34":[0],"12":[0],"8":[0],"19":[1],"23":[1],"4":[0],"40":[0],"15":[1],"11":[1],"9":[1],"44":[0],"33":[1],"22":[0],"26":[0],"37":[1],"13":[1],"46":[0],"24":[0],"35":[1],"16":[0],"5":[1],"10":[0],"21":[1],"43":[1],"32":[0],"6":[0],"36":[0],"1":[1],"39":[1],"17":[1],"25":[1],"14":[0],"47":[1],"31":[1],"42":[0],"0":[0],"20":[0],"27":[1],"2":[0],"38":[0],"18":[0],"30":[0],"7":[1],"29":[1],"41":[1],"3":[1],"28":[0]}} (kafka.admin.AdminUtils$)
Created topic "test-no-rep".
```
Run the producer to publish events to Kafka topic
> topic: test-no-rep
>
> num-records: 50000000 (50.000.000)
>
> record-size: 500
>
> throughput: 1
>
> producer-props: acks=1
>
> buffer.memory=104857600
>
> batch.size=9000
>
> bootstrap.servers=212.47.241.204:32400
```shell
bin/kafka-run-class.sh org.apache.kafka.tools.ProducerPerformance --topic test-no-rep --num-records 50000000 --record-size 500 --throughput -1 --producer-props acks=1 bootstrap.servers=bootstrap.kafka.svc.cluster.local:9092 buffer.memory=104857600 batch.size=9000

# Results
50000000 records sent, 23045.255351 records/sec (10.99 MB/sec), 8533.88 ms avg latency, 25037.00 ms max latency, 7982 ms 50th, 20351 ms 95th, 21875 ms 99th, 24272 ms 99.9th.
# Public Cloud
2000000 records sent, 51979.104400 records/sec (24.79 MB/sec), 3216.78 ms avg latency, 8489.00 ms max latency, 2809 ms 50th, 8092 ms 95th, 8315 ms 99th, 8462 ms 99.9th.
```

## Single producer publishing 500 byte messages with (3x) and with out replication
> The objective of this test is to understand the cost of the replication

create kafka topic (with replication)
```shell
bin/kafka-topics.sh --zookeeper zookeeper.kafka:2181 --create --topic test-3-rep --partitions 48 --replication-factor 3
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
