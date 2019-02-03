#!/usr/bin/env bash
# This script will deploy uc on node.
# You must run pre_bm_osp14.sh before this script
# Tzach Shefi
# 2/2018
# ver: 1.0

# RFE validate the pre_bm_osp14.sh has been run

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


#Bring repos


#Get post reboot next script


#update+reboot
sudo yum update -y
sudo reboot





