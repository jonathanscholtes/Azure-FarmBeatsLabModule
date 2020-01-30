#!/bin/sh
#curl https://packages.microsoft.com/config/debian/stretch/multiarch/prod.list > ./microsoft-prod.list
curl https://packages.microsoft.com/config/debian/10/prod.list > ./microsoft-prod.list
sudo cp ./microsoft-prod.list /etc/apt/sources.list.d/
curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo cp ./microsoft.gpg /etc/apt/trusted.gpg.d/
sudo apt-get update
sudo apt-get install moby-engine
sudo apt-get install moby-cli
sudo apt-get update
sudo apt-get install iotedge
sudo nano /etc/iotedge/config.yaml