#!/bin/bash

#Configuring network
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
cp ./nginx-network /etc/netplan/00-installer-config.yaml
netplan apply

#Installing and configurin Nginx
apt install nginx -y
systemctl enable nginx.service
cp /etc/nginx/sites-enabled/default /etc/nginx/sites-enabled/default.bak
cp ./nginx-default-config /etc/nginx/sites-enabled/default
service nginx restart

#Installing and configuring agents
apt install prometheus-node-exporter prometheus-nginx-exporter
systemctl enable --now prometheus-node-exporter
systemctl enable --now prometheus-nginx-exporter

dpkg -i https://cdn.otus.ru/media/public/65/6d/filebeat_8.9.1_amd64-224190-656d53.deb
cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bak
cp ./nginx-fbeats-config /etc/filebeat/filebeat.yml
systemctl enable --now filebeat.service
