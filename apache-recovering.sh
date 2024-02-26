#!/bin/bash

#Configuring network
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
cp ./apache-network /etc/netplan/00-installer-config.yaml
netplan apply

#Installing and configuring Apache
apt install apache2 -y
systemctl enable apache2.service
cp ./apache-both-ports-config /etc/apache2/ports.conf
service apache2 restart

#Installing and configuring MySQL server
apt install mysql-server -y
systemctl enable mysql.service
cp /etc/mysql/mysql.conf.d/mysqld.conf /etc/mysql/mysql.conf.d/mysqld.conf.bak
cp ./apache-mysql-config /etc/mysql/mysql.conf.d/mysqld.conf
mysql --execute="create user replica@'10.0.2.22' identified if 'caching_sha2_password' BY 'OtuS2024SuetiN';"
mysql --execute="grant replication slave on *.* to replica@'10.0.2.22';"

#Installing and configuring agents
apt install prometheus-node-exporter prometheus-apache-exporter prometheus-mysqld-exporter
systemctl enable --now prometheus-node-exporter
systemctl enable --now prometheus-apache-exporter
systemctl enable --now prometheus-mysqld-exporter

dpkg -i https://cdn.otus.ru/media/public/65/6d/filebeat_8.9.1_amd64-224190-656d53.deb
cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bak
cp ./apache-both-fbeats-config /etc/filebeat/filebeat.yml
systemctl enable --now filebeat.service
