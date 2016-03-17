#!/bin/bash

bundle exec rails runner '
#DOESNT WORK YET oVirt junk Wont work if youre not granted access to the webapi
#prov = ManageIQ::Providers::Redhat::InfraManager.new(:name => "rhev.tlv", :port => 443, :hostname => "rhev.tlv", :zone => Zone.first)
#prov.save
#Authentication.create(:name => "ManageIQ::Providers::Redhat::InfraManager rhev.tlv", :authtype => "default", :userid => "azellner@redhat.com", :password => "hunter2", :resource_id => prov.id, :resource_type => "ExtManagementSystem", :type => "AuthUseridPassword").save

prov = ManageIQ::Providers::Openshift::ContainerManager.new(:hostname => "'$1'", :port => 8443,  :name =>"'$2'", :zone => Zone.first)
prov.save
AuthToken.create(:name => "ManageIQ::Providers::Openshift::ContainerManager '$2'", :authtype => "bearer", :userid => "_", :resource_id => prov.id, :resource_type => "ExtManagementSystem", :type => "AuthToken", :auth_key => "'$3'").save
EmsRefresh.refresh(prov)
'
