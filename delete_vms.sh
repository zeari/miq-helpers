#! /usr/bin/bash

VM_1_name="openshift-vm-4-centos-7.1-x86_64"
VM_2_name="openshift-vm-5-centos-7.1-x86_64"

sudo virt-deploy stop $VM_1_name
sudo virt-deploy stop $VM_2_name

sudo virt-deploy delete $VM_1_name
sudo virt-deploy delete $VM_2_name
