#!/bin/sh
myuid=$(id -u)
mygid=$(id -g)
uidentry=$(getent passwd $myuid)

if [ -z "$uidentry" ] ; then
    # assumes /etc/passwd has root-group (gid 0) ownership
    echo "$myuid:x:$myuid:$mygid:anonymous uid:/tmp:/bin/false" >> /etc/passwd
fi

if [[ $MASTER == "true" ]]; then
    /opt/spark-distro/spark-2.3.0-bin-hadoop2.7/bin/spark-class org.apache.spark.deploy.master.Master
else
    /opt/spark-distro/spark-2.3.0-bin-hadoop2.7/bin/spark-class org.apache.spark.deploy.worker.Worker spark://$SPARK_MASTER:7077
fi
