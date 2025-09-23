#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt autoremove
sudo apt clean
echo 'System upgrades successful!'
