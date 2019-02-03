#!/usr/bin/env bash
# This script will deploy uc on node.
# You must run pre_bm_osp14.sh before this script
# Tzach Shefi
# 2/2018
# ver: 1.0

# RFE validate the pre_bm_osp14.sh has been run
mkdir ~/images
mkdir ~/templates

#get file
wget http://file.tlv.redhat.com/~tshefi/bm/instackenvAll.json


sudo yum install -y python-tripleoclient
#Needed only if we deploy with ceph, but doesn't hurt to add now.
sudo yum install -y ceph-ansible


#3.2. Preparing container images


