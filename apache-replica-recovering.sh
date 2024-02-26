#!/bin/bash

#Configuring network
cp /etc/netplan/00-installer-config.yaml /etc/netplan/00-installer-config.yaml.bak
cp ./apache-replica-network /etc/netplan/00-installer-config.yaml
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
cp ./apache-replica-mysql-config /etc/mysql/mysql.conf.d/mysqld.conf
mysql --execute="stop replica;"
mysql --execute="change master to master_host='10.0.2.21', master_user='replica', master_password='OtuS2024SuetiN', master_log_file='binlog.000005', master_log_pos=688, get_master_public_key = 1;"
mysql --execute="start replica;"

#Installing and configuring agents
apt install prometheus-node-exporter prometheus-apache-exporter prometheus-mysqld-exporter
systemctl enable --now prometheus-node-exporter
systemctl enable --now prometheus-apache-exporter
systemctl enable --now prometheus-mysqld-exporter

dpkg -i https://cdn.otus.ru/media/public/65/6d/filebeat_8.9.1_amd64-224190-656d53.deb
cp /etc/filebeat/filebeat.yml /etc/filebeat/filebeat.yml.bak
cp ./apache-both-fbeats-config /etc/filebeat/filebeat.yml
systemctl enable --now filebeat.service
