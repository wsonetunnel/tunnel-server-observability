#! /bin/bash

if [ $# -ne 1 ]; then
   echo "Run setup.sh with: 
	tunall: if all tunnel components need to run
	tunall-syslog: if everything except syslog needs to be deployed
	tunall-sys-gra: if everthing except syslog and grafana needs to be deployed
        ws1all: if all ws1 components like Grafana, Loki and Prometheus needs to be deployed
        clean: clean up all containers"
   exit 1
fi

case "$1" in
  "tunall")
       docker-compose up --build --force-recreate -d; shift;;
  "tunall-sys") 
       docker-compose up --build --force-recreate -d influxdb telegraf grafana loki promtail; shift;;
  "tunall-sys-gra")  
       docker-compose up --build --force-recreate -d influxdb telegraf loki promtail; shift;;
  "ws1all")
       docker-compose -f docker-compose-glp.yml up --build --force-recreate -d; shift;;  
  "clean")  
       docker-compose down --remove-orphans; shift;; 
esac
