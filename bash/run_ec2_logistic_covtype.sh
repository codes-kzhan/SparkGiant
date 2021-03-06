#!/usr/bin/env bash

PROJ_HOME="/root/SparkGiant"

export JAR_DIR="$PROJ_HOME/target/scala-2.11"
export JAR_FILE="$JAR_DIR/giant_2.11-1.0.jar"
cp $JAR_FILE /root/share/
/root/spark-ec2/copy-dir /root/share/

export DATA_FILE_HDFS1="hdfs://"`cat /root/spark-ec2/masters`":9000/covtype_train"
export DATA_FILE_HDFS2="hdfs://"`cat /root/spark-ec2/masters`":9000/covtype_test"

NUM_SPLITS="2"
NUM_FEATURE="200"

/root/spark/bin/spark-submit \
    --class "distopt.logistic.ExperimentCovtype" \
    --master `cat /root/spark-ec2/cluster-url` \
    --num-executors $NUM_SPLITS \
    --driver-memory 12G \
    --executor-memory 4G \
    --executor-cores 2 \
    $JAR_FILE $DATA_FILE_HDFS1 $DATA_FILE_HDFS2 $NUM_FEATURE $NUM_SPLITS \
    > Result_FEATURE"$NUM_FEATURE".out

  
  