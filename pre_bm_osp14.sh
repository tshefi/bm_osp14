#!/usr/bin/env bash
# Automated script to pre_deploy OSP14 on BM
# Tzach Shefi
# 2/2018
# ver: 1.0
# This script does all the pre UC deploy tasks and reboots.
# a second bash script will continue work post reboot.
# wget https://raw.githubusercontent.com/tshefi/bm_osp14/master/pre_bm_osp14.sh  && chmod +x pre_bm_osp14.sh && ./pre_bm_osp14.sh


# RFE - Clean hosts via foreman ?

#Clean puppets from foreman!!
yum remove puppet* -y

# All step numbers reference install guide:
# https://access.redhat.com/documentation/en-us/red_hat_openstack_platform/14-beta/html/director_installation_and_usage/preparing-for-director-installation#preparing-the-undercloud

# 3.1. Preparing the undercloud
#create user stack pass stack
echo  "127.0.0.1   "$(hostname)"  "$(hostname -s)  >> /etc/hosts
useradd stack
echo stack | passwd stack --stdin
echo "stack ALL=(root) NOPASSWD:ALL" | tee -a /etc/sudoers.d/stack
chmod 0440 /etc/sudoers.d/stack

#Fix remove/reinstall repos
yum remove -y rhos-release
rpm -ivh http://rhos-release.virt.bos.redhat.com/repos/rhos-release/rhos-release-latest.noarch.rpm
rm -rf /etc/yum.repos.d/*
rm -rf /var/cache/yum/*
rhos-release 14-director > /home/stack/version.txt


#Get post reboot next script
wget -O /home/stack/osp14_uc_deploy.sh https://raw.githubusercontent.com/tshefi/bm_osp14/master/osp14_uc_deploy.sh /home/stack/osp14_uc_deploy.sh
chmod +x /home/stack/osp14_uc_deploy.sh


#update+reboot
yum update -y
reboot