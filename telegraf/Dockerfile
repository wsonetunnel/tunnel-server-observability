FROM telegraf:1.24

USER root

ADD telegraf.conf.template /telegraf.conf.template
COPY *.conf /etc/telegraf/telegraf.d/

ADD mibs/* /usr/share/snmp/mibs/

ADD run.sh /run.sh
ENTRYPOINT ["bash", "/run.sh"]
