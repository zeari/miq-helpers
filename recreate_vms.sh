#! /usr/bin/bash

VM_1_name="openshift-vm-4-centos-7.1-x86_64"
VM_2_name="openshift-vm-5-centos-7.1-x86_64"

./delete_vms.sh

sudo virt-deploy create openshift-vm-4 centos-7.1 | tee /tmp/vm_1_dits
sudo virt-deploy create openshift-vm-5 centos-7.1 | tee /tmp/vm_2_dits

sudo virt-deploy start $VM_1_name
sudo virt-deploy start $VM_2_name

vm_1_ip=`grep ip /tmp/vm_1_dits  | cut -d" " -f3`
vm_2_ip=`grep ip /tmp/vm_2_dits  | cut -d" " -f3`
vm_1_pass=`grep "root password" /tmp/vm_1_dits  | cut -d" " -f3`
vm_2_pass=`grep "root password" /tmp/vm_2_dits  | cut -d" " -f3`

sudo grep -v openshift-vm-[45]-centos-7.1-x86_64  /etc/hosts > /tmp/hosts
sudo echo "$vm_1_ip $VM_1_name" >> /tmp/hosts
sudo echo "$vm_2_ip $VM_2_name" >> /tmp/hosts
sudo cp /tmp/hosts /etc/hosts

ssh-keygen -R $VM_1_name
ssh-keygen -R $VM_2_name
sleep 10

echo $vm_1_pass
ssh-keyscan $VM_1_name >> ~/.ssh/known_hosts
sshpass -p $vm_1_pass ssh-copy-id root@$VM_1_name

echo $vm_2_pass
ssh-keyscan $VM_2_name >> ~/.ssh/known_hosts
sshpass -p $vm_2_pass ssh-copy-id root@$VM_2_name
