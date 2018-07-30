# Kafka Administration
> https://github.com/jaceklaskowski/kafka-notebook/blob/master/kafka-topic-deletion.adoc

## Change port
Take a back up of kafka-run-class.sh (such as cp kafka-run-class.sh kafka-run-class.sh.old).
```shell
vi kafka-run-class.sh
```
Change the following section:
```shell
# JMX port to use 
if [ $JMX_PORT ]; then 
KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.port=$JMX_PORT" 
fi
```

To the following:
```shell
# JMX port to use 
if [ $ISKAFKASERVER = "true" ]; then 
JMX_REMOTE_PORT=$JMX_PORT 

else 
JMX_REMOTE_PORT=$CLIENT_JMX_PORT 
fi 

if [ $JMX_REMOTE_PORT ]; then 
KAFKA_JMX_OPTS="$KAFKA_JMX_OPTS -Dcom.sun.management.jmxremote.port=$JMX_REMOTE_PORT" 
fi
```

## Create Topic
```shell
bin/kafka-topics.sh --create --zookeeper <your_zookeeper_host>:2181 --replication-factor <number_of_replicas> --partitions <number_of_partitions> --topic <name_of_your_topic>
```

## List Topics
```shell
$ ./bin/kafka-topics.sh --zookeeper zookeeper.kafka:2181 --list
MY_TOPIC
__consumer_offsets
a516817-kentekens
ops.kube-events.stream.json
test
test-no-rep
```

## Describe Topics
```shell
$ ./bin/kafka-topics.sh --zookeeper zookeeper.kafka:2181 --describe --topic test-no-rep
Topic:test-no-rep       PartitionCount:48       ReplicationFactor:1     Configs:
        Topic: test-no-rep      Partition: 0    Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 1    Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 2    Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 3    Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 4    Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 5    Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 6    Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 7    Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 8    Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 9    Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 10   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 11   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 12   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 13   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 14   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 15   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 16   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 17   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 18   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 19   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 20   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 21   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 22   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 23   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 24   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 25   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 26   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 27   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 28   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 29   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 30   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 31   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 32   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 33   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 34   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 35   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 36   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 37   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 38   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 39   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 40   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 41   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 42   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 43   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 44   Leader: 0       Replicas: 0     Isr: 0
        Topic: test-no-rep      Partition: 45   Leader: 1       Replicas: 1     Isr: 1
        Topic: test-no-rep      Partition: 46   Leader: 2       Replicas: 2     Isr: 2
        Topic: test-no-rep      Partition: 47   Leader: 0       Replicas: 0     Isr: 0
```

## Remove topic
```shell
$ ./bin/kafka-topics.sh --zookeeper zookeeper.kafka:2181 --delete --topic test-no-rep
Topic test-no-rep is marked for deletion.
```
