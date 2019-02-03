#!/usr/bin/env bash
# Automated script to pre_deploy OSP14 on BM
# Tzach Shefi
# 2/2018
# ver: 1.0
# This script does all the pre UC deploy tasks and reboots.
# a second bash script will continute work post reboot.


# RFE - Clean hosts via foreman ?

#Clean puppets from foreman!!
yum remove puppet* -y

# All step numbers reference install guide:
#https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/14-beta/html/director_installation_and_usage/preparing-for-director-installation#preparing-the-undercloud

# 3.1. Preparing the undercloud
#create user stack pass stack
useradd stack
passwd stack
echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack
echo  "127.0.0.1   "$(hostname)"  "$(hsotname -s)  >> /etc/hosts

#Create stack user
su - stack
mkdir ~/images
mkdir ~/templates


#Fix remove/reinstall repos
sudo yum remove -y rhos-release
sudo rpm -ivh http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm
sudo rm -rf /etc/yum.repos.d/*
sudo rm -rf /var/cache/yum/*
sudo rhos-release 10-director > /home/stack/version.txt


#Get post reboot next script
wget
chmod +x

#update+reboot
sudo yum update -y
sudo reboot