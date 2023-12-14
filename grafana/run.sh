#!/bin/bash -e

: "${GF_PATHS_DATA:=/var/lib/grafana}"
: "${GF_PATHS_LOGS:=/var/log/grafana}"
: "${GF_PATHS_PLUGINS:=/var/lib/grafana/plugins}"
: "${GF_PATHS_PROVISIONING:=/etc/grafana/provisioning}"

chown -R grafana:grafana "$GF_PATHS_DATA" "$GF_PATHS_LOGS"
chown -R grafana:grafana /etc/grafana

# Install all available plugins
if [ "${GRAFANA_PLUGINS_ENABLED}" != "false" ]
then
  if [ -z "${GRAFANA_PLUGINS}" ]
  then
    GRAFANA_PLUGINS=`grafana-cli plugins list-remote | awk '{print $2}'| grep "-"`
  fi
  for plugin in ${GRAFANA_PLUGINS}; 
  do
    if [ ! -d ${GF_PATHS_PLUGINS}/$plugin ]
    then
      grafana-cli plugins install $plugin || true;
    else
      echo "Plugin $plugin already installed"
    fi
  done
fi

# Start grafana with gosu
exec gosu grafana /usr/share/grafana/bin/grafana-server  \
  --homepath=/usr/share/grafana             \
  --config=/etc/grafana/grafana.ini         \
  cfg:default.paths.data="$GF_PATHS_DATA"   \
  cfg:default.paths.logs="$GF_PATHS_LOGS"   \
  cfg:default.paths.plugins="$GF_PATHS_PLUGINS" &

sleep 5

###############################################################

echo "GRAFANA_URL: "$GRAFANA_URL >> $GF_PATHS_LOGS/grafana.log
echo "GRAFANA_PORT: "$GRAFANA_PORT >> $GF_PATHS_LOGS/grafana.log
echo "GRAFANA_USER: "$GRAFANA_USER >> $GF_PATHS_LOGS/grafana.log
echo "GRAFANA_PASSWORD: "$GRAFANA_PASSWORD >> $GF_PATHS_LOGS/grafana.log

tail -f $GF_PATHS_LOGS/grafana.log
