FROM grafana/grafana:10.2.2-ubuntu

USER root

RUN apt-get -q update &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q upgrade -y -o Dpkg::Options::="--force-confnew" --no-install-recommends &&\
    DEBIAN_FRONTEND="noninteractive" apt-get -q install -y -o Dpkg::Options::="--force-confnew" --no-install-recommends curl gosu &&\
    apt-get -q autoremove &&\
    apt-get -q clean -y && rm -rf /var/lib/apt/lists/* && rm -f /var/cache/apt/*.bin

RUN mkdir -p /opt/grafana/dashboards
ADD ./provisioning/dashboard/Monitoring.json /opt/grafana/dashboards/
ADD ./provisioning/dashboard/default-dashboard.yaml /etc/grafana/provisioning/dashboards/

ADD run.sh /run.sh
ENTRYPOINT ["bash", "/run.sh"]
