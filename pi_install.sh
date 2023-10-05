#!/bin/bash

#add influxdb repo
curl https://repos.influxdata.com/influxdata-archive.key | gpg --dearmor | sudo tee /usr/share/keyrings/influxdb-archive-keyring.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/influxdb-archive-keyring.gpg] https://repos.influxdata.com/debian stable main" | sudo tee /etc/apt/sources.list.d/influxdb.list

#add grafana repo
curl https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /usr/share/keyrings/grafana-archive-keyrings.gpg >/dev/null
echo "deb [signed-by=/usr/share/keyrings/grafana-archive-keyrings.gpg] https://apt.grafana.com stable main" | sudo tee /etc/apt/sources.list.d/grafana.list

#update and upgrade
sudo apt update
sudo apt upgrade -y

#install mqtt & config
sudo apt install mosquitto -y
sudo apt install mosquitto-clients -y

sudo echo "listener 1883" >> /etc/mosquitto/mosquitto.conf
sudo echo "allow_anonymous true" >> /etc/mosquitto/mosquitto.conf

sudo systemctl restart mosquitto.service

#install influxdb & config
sudo apt install influxdb2 -y
sudo systemctl enable influxdb.service
sudo systemctl start influxdb.service

#install grafana & config
sudo apt install grafana -y
sudo systemctl enable grafana-server.service
sudo systemctl start grafana-server.service

#install node-red & config
bash <(curl -sL https://raw.githubusercontent.com/node-red/linux-installers/master/deb/update-nodejs-and-nodered)

sudo systemctl enable nodered.service
sudo systemctl start nodered.service

#clean
history -c
echo -n > .bash_history
rm pi_install.sh
clear
