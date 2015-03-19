#!/bin/bash
 
HOSTNAME="${COLLECTD_HOSTNAME:-`hostname -f`}"
INTERVAL="${COLLECTD_INTERVAL:-10}"
REDIS_CLI=`which redis-cli`
PORT=6379

 
while sleep "$INTERVAL"
do

  #info=$(echo info|nc -w 1 127.0.0.1 $PORT)
  info=`$REDIS_CLI -p $PORT info`
  connected_clients=$(echo "$info"|awk -F : '$1 == "connected_clients" {print $2}')
  connected_slaves=$(echo "$info"|awk -F : '$1 == "connected_slaves" {print $2}')
  uptime=$(echo "$info"|awk -F : '$1 == "uptime_in_seconds" {print $2}')
  used_memory=$(echo "$info"|awk -F ":" '$1 == "used_memory" {print $2}'|sed -e 's/\r//')
  changes_since_last_save=$(echo "$info"|awk -F : '$1 == "changes_since_last_save" {print $2}')
  total_commands_processed=$(echo "$info"|awk -F : '$1 == "total_commands_processed" {print $2}')
  keys=$(echo "$info"|egrep -e "^db0"|sed -e 's/^.\+:keys=//'|sed -e 's/,.\+//')
  keyspace_misses=$(echo "$info"|awk -F : '$1 == "keyspace_misses" {print $2}')
  keyspace_hits=$(echo "$info"|awk -F : '$1 == "keyspace_hits" {print $2}')
  rejected_connections=$(echo "$info"|awk -F : '$1 == "rejected_connections" {print $2}')
  evicted_keys=$(echo "$info"|awk -F : '$1 == "evicted_keys" {print $2}')
   
  echo "PUTVAL $HOSTNAME/redis-$PORT/memcached_connections-clients interval=$INTERVAL N:$connected_clients"
  echo "PUTVAL $HOSTNAME/redis-$PORT/memcached_connections-slaves interval=$INTERVAL N:$connected_slaves"
  echo "PUTVAL $HOSTNAME/redis-$PORT/uptime interval=$INTERVAL N:$uptime"
  echo "PUTVAL $HOSTNAME/redis-$PORT/df-memory interval=$INTERVAL N:$used_memory:U"
  echo "PUTVAL $HOSTNAME/redis-$PORT/files-unsaved_changes interval=$INTERVAL N:$changes_since_last_save"
  echo "PUTVAL $HOSTNAME/redis-$PORT/memcached_command-total interval=$INTERVAL N:$total_commands_processed"
  echo "PUTVAL $HOSTNAME/redis-$PORT/memcached_items-db0 interval=$INTERVAL N:$keys"
  echo "PUTVAL $HOSTNAME/redis-$PORT/objects-keyspace_misses interval=$INTERVAL N:$keyspace_misses"
  echo "PUTVAL $HOSTNAME/redis-$PORT/objects-keyspace_hits interval=$INTERVAL N:$keyspace_hits"
  echo "PUTVAL $HOSTNAME/redis-$PORT/connections-rejected interval=$INTERVAL N:$rejected_connections"
  echo "PUTVAL $HOSTNAME/redis-$PORT/objects-evicted_keys interval=$INTERVAL N:$evicted_keys"

done
