#!/bin/bash

bundle exec rails runner '
ManageIQ::Providers::Kubernetes::ContainerManager.destroy_all
ManageIQ::Providers::Openshift::ContainerManager.destroy_all
#ManageIQ::Providers::Redhat::InfraManager.destroy_all

prov = ManageIQ::Providers::Kubernetes::ContainerManager.new(:hostname => "localhost", :port => 8443, :name =>"localkube", :hostname => "localhost" , :zone => Zone.first)
prov.save
EmsRefresh.refresh(prov)
ContainerImageRegistry.create(:host => "exampleHost", :name => "exampleHost", :port=>"1234").save

#DOESNT WORK YET oVirt junk Wont work if youre not granted access to the webapi
#prov = ManageIQ::Providers::Redhat::InfraManager.new(:name => "rhev.tlv", :port => 443, :hostname => "rhev.tlv", :zone => Zone.first)
#prov.save
#Authentication.create(:name => "ManageIQ::Providers::Redhat::InfraManager rhev.tlv", :authtype => "default", :userid => "azellner@redhat.com", :password => "hunter2", :resource_id => prov.id, :resource_type => "ExtManagementSystem", :type => "AuthUseridPassword").save

prov = ManageIQ::Providers::Openshift::ContainerManager.new(:hostname => "oshift01.eng.lab.tlv.redhat.com", :port => 8443,  :name =>"Molecule", :zone => Zone.first)
prov.save
AuthToken.create(:name => "ManageIQ::Providers::Openshift::ContainerManager molecule", :authtype => "bearer", :userid => "_", :resource_id => prov.id, :resource_type => "ExtManagementSystem", :type => "AuthToken", :auth_key => "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJtYW5hZ2VtZW50LWluZnJhIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im1hbmFnZW1lbnQtYWRtaW4tdG9rZW4tMThmaTAiLCJrdWJlcm5ldGVzLmlvL3NlcnZpY2VhY2NvdW50L3NlcnZpY2UtYWNjb3VudC5uYW1lIjoibWFuYWdlbWVudC1hZG1pbiIsImt1YmVybmV0ZXMuaW8vc2VydmljZWFjY291bnQvc2VydmljZS1hY2NvdW50LnVpZCI6ImQ5MjYyYjVjLThmN2ItMTFlNS1hODA2LTAwMWE0YTIzMTI5MCIsInN1YiI6InN5c3RlbTpzZXJ2aWNlYWNjb3VudDptYW5hZ2VtZW50LWluZnJhOm1hbmFnZW1lbnQtYWRtaW4ifQ.mWvcSwE6_WR8mHm_QBrXM_IHF9I9qOvfB-9Le-g7_DTrzEcM6Jy5smR6v7XmwRizjCheQJxbLjHmATxOXZGxyiG9ZXQGht1TcenCsLKJzxeVp5Lt3K9hdnFdXS9bXNHRav8VNpTwnjS2mRnzGQNxop2BJ1nGWU1mzMSyK5hWKoaUSVKsKwT1UyPfPC6_we-ygjhZpIbSxPEalzm_tjTUFSdWvUFlNBzUQrHvE0zoPxJ4sbbC5uNcaWo7aTey4eIcAn9vnPvNzHTJTIzbVyYIp65jehUr2QKD0CvGAjLWS_Pp-EeINOWaEQe_xNxK0IAl8b4uwhPVc-rRjFb4GkqVoQ").save
EmsRefresh.refresh(prov)
'
