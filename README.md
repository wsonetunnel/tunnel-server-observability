Overview
========

This repo can be used as a recommendation for guidance on setting up tunnel server observability (Logging and Telemetry)

Pre-reqs
========

* Tunnel configured on UEM Console.Follow the existing steps to configure syslog in UEM Console and enabling snmp(if using UAG).
* Tunnel Server deployed through UAG or container
* All connectivity should be working as expected.


Logging and Telemetry
=====================

Set Up
------

* Deploy Linux VM 
    * Chose distribution of your choice, though photonOS template is provided for use. You can also choose to download [here](https://github.com/vmware/photon/wiki/Downloading-Photon-OS) 
        * Resource recommendation of Linux VM 4 core 16GB 100 GB storage ___TBD___
        * Retention policy ___TBD___
    * Ensure, docker is installed on Linux VM. Run `docker version` to confirm the same.
    * Start docker using `systemctl start docker`
* Clone the [repo](https://stash.air-watch.com/users/akochhar/repos/tunnel-server-observability/browse) on Linux VM OR download to your local,zip the entire repo and transfer it to VM.
* Login to VM
* Go to directory where repo is cloned or unzip it if zipped.
* open [.env](./.env) file in this directory and fill in the below information
```
TELEGRAF_HOST=<LINUX VM IP>

INFLUXDB_HOST=<LINUX VM IP>
INFLUXDB_PORT=8086
DOCKER_INFLUXDB_INIT_MODE=setup
DOCKER_INFLUXDB_INIT_USERNAME=<INFLUXDB USERNAME>
DOCKER_INFLUXDB_INIT_PASSWORD=<INFLUXDB PASSWORD>
DOCKER_INFLUXDB_INIT_ORG=snmp
DOCKER_INFLUXDB_INIT_BUCKET=metrics
DOCKER_INFLUXDB_INIT_ADMIN_TOKEN=metrics

GRAFANA_PORT=3000
GRAFANA_URL=<LINUX VM IP>
GRAFANA_USER=<GRAFANA USERNAME>
GRAFANA_PASSWORD=<GRAFANA PASSWORD>
GRAFANA_PLUGINS_ENABLED=true
GRAFANA_PLUGINS=grafana-piechart-panel

TUNNEL_SERVER_IP=<TUNNEL SERVER IP> --> Only one server supported right now
```
* Run `docker-compose up --build --force-recreate -d`
* Open any browser on your local OR any machine which has connectivity to the Linux VM and type `http://<linux-vm-ip>:3000`
    * You can view the logs and stats here.

Configuration
-------------

* Configure syslog (Linux VM IP or URL/hostname) on UEM Console and save the configuration.
    * This will send access log to server. Assumption is the syslog server runs on port 514.
    * For application (tunnel server) logs, configure kvp settings as well. ___WIP___
* Tunnel Server container already exposes port 161 for snmp stats. In UAG, enable snmp following guide [here](https://docs.vmware.com/en/Unified-Access-Gateway/2303/uag-deploy-config/GUID-F71E6283-E24B-49F5-8AC6-D28915CD41AD.html)

Tests
-----

1. Enroll a device and try accessing any tunnel’ed resource from any enrolled device. 
2. You should start seeing the logs and stats `http://<linux-vm-ip>:3000`

![Tunnel Stats and Logs](./docs/grafana.png)

Reference documents
-------------------

* [Syslog Configuration](https://docs.vmware.com/en/VMware-Workspace-ONE-UEM/services/VMware_Tunnel/GUID-471260BA-4DDC-4BFE-B8C3-FA2DDC2116A1.html)
* [SNMP Configuration in UAG](https://docs.vmware.com/en/Unified-Access-Gateway/2303/uag-deploy-config/GUID-F71E6283-E24B-49F5-8AC6-D28915CD41AD.html)
