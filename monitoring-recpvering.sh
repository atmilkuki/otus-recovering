#!/bin/bash

#Configuring network
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
cp ./monitoring-network /etc/netplan/00-installer-config.yaml
netplan apply

#Installing and configuring Prometheus
apt install prometeheus prometheus-node-exporter -y
systemctl enable --now prometeheus
systemctl enable --now prometeheus-node-exporter
cp ./monitoring-prometheus-config /etc/prometheus/prometheus.yml
service prometheus restart

#Installing Grafana
dpkg -i https://cdn.otus.ru/media/public/46/0a/grafana_10.2.2_amd64_224190_2cad86-224190-460adc.deb
apt -f install
systemctl enable --now grafana-server

#Installing and configuring Logstash
dpkg -i https://cdn.otus.ru/media/public/e7/a1/logstash_8.9.1_amd64-224190-e7a1b1.deb
systemctl enable --now logstash
cp ./monitoring-logstash-config /etc/logstash/logstash.yml
service logstash restart

#Installing and configuring Elasticsearch
dpkg -i https://cdn.otus.ru/media/public/50/9c/elasticsearch_8.9.1_amd64-224190-509cdd.deb
systemctl enable --now elasticsearch
cp ./monitoring-elastic-config /etc/elasticsearch/elasticsearch.yml
service elasticsearch restart

#Installing and configuring Kibana
dpkg -i https://cdn.otus.ru/media/public/c0/98/kibana_8.9.1_amd64-224190-c09868.deb
systemctl enable --now kibana
cp ./monitoring-kibana-config /etc/kibana/kibana.yml
service kibana restart
