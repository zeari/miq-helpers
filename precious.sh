#!/bin/bash

set -e
set -u

source colors.sh

function clean_up {
	printRed "Error"
	exit
}

trap clean_up SIGHUP SIGINT SIGTERM ERR

sudo echo poop

sudo docker stop $(sudo docker ps -a -q) || true
sudo docker rm $(sudo docker ps -a -q) || true

#sudo docker run -d --name "openshift-origin" --net=host --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/openshift:/tmp/openshift openshift/origin:v0.5.2 start
sudo docker run -d --name "openshift-origin" --net=host --privileged -v /var/run/docker.sock:/var/run/docker.sock -v /tmp/openshift:/tmp/openshift openshift/origin start
sleep 3

until sudo docker exec -it openshift-origin bash -c "openshift admin --config=/var/lib/openshift/openshift.local.config/master/admin.kubeconfig policy add-cluster-role-to-group cluster-admin system:authenticated system:unauthenticated" &> /dev/null
do
	sleep 3
done

sleep 2

sudo docker exec -it openshift-origin bash -c 'osc process -f https://raw.githubusercontent.com/openshift/origin/master/examples/sample-app/application-template-dockerbuild.json | osc create -f -'

echo -e "\a"
sleep 0.1
echo -e "\a"
echo -e "\a"
sleep 0.1
echo -e "\a"
sleep 0.1
echo -e "\a"
sleep 0.1

printBlue "All done. :)"

notify-send "Done setting up openshift locally "
