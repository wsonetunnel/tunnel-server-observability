#! /bin/bash

if [ $# -ne 1 ]; then
   echo "Run setup.sh with: 
	0: if all components need to run
	1: if everything except syslog needs to be deployed
	2: if everthing except syslog and grafana needs to be deployed "
   exit 1
fi

case "$1" in
  "0")
       docker-compose up --build --force-recreate -d; shift;;
  "1") 
       docker-compose up --build --force-recreate -d influxdb telegraf grafana loki promtail; shift;;
  "2")  
       docker-compose up --build --force-recreate -d influxdb telegraf loki promtail; shift;;
esac
