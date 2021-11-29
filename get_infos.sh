#!/bin/bash
#
GRAFANA_USER="admin"
GRAFANA_SENHA="$(kubectl get secret --namespace monitoring loki-grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo)"
GRAFANA_URL="$(kubectl get service --namespace monitoring loki-grafana | awk {'print $4'})"

NGINX_URL="$(kubectl get service --namespace monitoring loki-grafana | awk {'print $4'})"

echo -e "URL pod teste: \n"
echo "http://$NGINX_URL"


echo -e "\nAcesso Grafana: \n"
echo "http://$GRAFANA_URL"
echo "User: $GRAFANA_USER"
echo "Password: $GRAFANA_SENHA"