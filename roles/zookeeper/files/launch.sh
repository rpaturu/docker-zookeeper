#!/bin/bash

set -eo pipefail

export HOST_IP=${HOST_IP:-172.17.8.101}
export ETCD=$HOST_IP:4001

echo "[zookeeper] booting container. ETCD: $ETCD"

until confd -onetime -node $ETCD -config-file /etc/confd/conf.d/zoo.toml > /var/log/confd.log 2>&1; do
  echo "[zookeeper] waiting for confd to refresh zoo.cfg"
  sleep 5
done

# Set zookeeper id during launch
rm -f /var/lib/zookeeper/myid
touch /var/lib/zookeeper/myid
echo $1 > /var/lib/zookeeper/myid

# Run zookeeper service in foreground
/usr/share/zookeeper/bin/zkServer.sh start-foreground

# Run confd in the background to watch the upstream servers
confd -interval 120 -quiet -node $ETCD -config-file /etc/confd/conf.d/zoo.toml > /var/log/confd.log 2>&1

# Tail all zookeeper log files
tail -f /var/log/zookeeper/*.log
