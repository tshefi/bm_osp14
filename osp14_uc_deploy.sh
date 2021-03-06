#!/usr/bin/env bash
# This script will deploy uc on node.
# You must run pre_bm_osp14.sh before this script
# Tzach Shefi
# 2/2018
# ver: 1.0

set x

# RFE validate the pre_bm_osp14.sh has been run
mkdir ~/images
mkdir ~/templates
mkdir ~/bm

sudo yum install -y python-tripleoclient
#Needed only if we deploy with ceph, but doesn't hurt to add now.
sudo yum install -y ceph-ansible


#3.2. Preparing container images
openstack tripleo container image prepare default --local-push-destination --output-env-file containers-prepare-parameter.yaml
# ^this is the default external client path, I need to "patch" it for internal use




#3.5 Modify c-vol
#sudo openstack tripleo container image prepare -e ~/containers-prepare-parameter.yaml
# TBD fix c-vol image-------------------------------------


#4.1. Configuring the director
sed '164ilocal_interface=eno1' /usr/share/python-tripleoclient/undercloud.conf.sample > ~/undercloud.conf

#4.3. Installing the director
openstack undercloud install


#4.4. Obtaining images for overcloud nodes
source ~/stackrc
sudo yum install rhosp-director-images -y
cd ~/images
for i in /usr/share/rhosp-director-images/overcloud-full-latest-14.0.tar /usr/share/rhosp-director-images/ironic-python-agent-latest-14.0.tar; do tar -xvf $i; done
openstack overcloud image upload --image-path /home/stack/images/



#4.5. Setting a nameserver for the control plane
openstack subnet set $( openstack subnet list  | awk '{print $2}' | grep "-") --dns-nameserver 10.46.0.31


#6.1. Registering Nodes for the Overcloud
wget http://file.tlv.redhat.com/~tshefi/bm/instackenvAll.json
openstack overcloud node import ~/instackenvAll.json


#6.2. Inspecting the hardware of nodes
#openstack overcloud node introspect --all-manageable --provide
#-------------- TBD check that all nodes boot from 1G---------------


#6.3. Tagging nodes into profiles
#tag compute nodes: nodes cougar01/07
openstack baremetal node set --property capabilities='profile:compute,boot_option:local' $(openstack baremetal node list | grep cougar01 | awk {'print $2'})
openstack baremetal node set --property capabilities='profile:compute,boot_option:local' $(openstack baremetal node list | grep cougar07 | awk {'print $2'})

#tag controller nodes cougar08/09/16
openstack baremetal node set --property capabilities='profile:control,boot_option:local' $(openstack baremetal node list | grep cougar08 | awk {'print $2'})
openstack baremetal node set --property capabilities='profile:control,boot_option:local' $(openstack baremetal node list | grep cougar09 | awk {'print $2'})
openstack baremetal node set --property capabilities='profile:control,boot_option:local' $(openstack baremetal node list | grep cougar16 | awk {'print $2'})



#6.7. Creating an environment file that defines node counts and flavors
#bring file.
cd ~/bm
wget http://file.tlv.redhat.com/~tshefi/bm/bm/nodes_data.yaml
wget http://file.tlv.redhat.com/~tshefi/bm/bm/debug.yaml
wget http://file.tlv.redhat.com/~tshefi/bm/bm/extra_templates.yaml
cd ~
wget http://file.tlv.redhat.com/~tshefi/bm/overcloud_deploy.sh

