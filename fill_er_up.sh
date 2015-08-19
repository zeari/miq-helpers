#!/bin/bash

bundle exec rails runner '
ManageIQ::Providers::Kubernetes::ContainerManager.destroy_all
ManageIQ::Providers::Openshift::ContainerManager.destroy_all
ManageIQ::Providers::Redhat::InfraManager.destroy_all

prov = ManageIQ::Providers::Kubernetes::ContainerManager.new(:hostname => "localhost", :port => 8443,  :name =>"localkube", :ipaddress => "127.0.0.1" , :zone => Zone.first).save;
EmsRefresh.refresh(prov);

ContainerImageRegistry.create(:host => "exampleHost", :name => "exampleHost", :port=>"1234").save;

#DOESNT WORK YET oVirt junk Wont work if youre not granted access to the webapi
#prov = ManageIQ::Providers::Redhat::InfraManager.new(:name => "rhev.tlv", :port => 443, :hostname => "rhev.tlv", :zone => Zone.first);
#prov.save;
#Authentication.create(:name => "ManageIQ::Providers::Redhat::InfraManager rhev.tlv", :authtype => "default", :userid => "azellner@redhat.com", :password => "hunter2", :resource_id => prov.id, :resource_type => "ExtManagementSystem", :type => "AuthUseridPassword").save


prov = ManageIQ::Providers::Openshift::ContainerManager.new(:hostname => "oshift01.eng.lab.tlv.redhat.com", :port => 8443,  :name =>"Molecule", :zone => Zone.first)
prov.save;
AuthToken.create(:name => "ManageIQ::Providers::Openshift::ContainerManager molecule", :authtype => "bearer", :userid => "_", :resource_id => prov.id, :resource_type => "ExtManagementSystem", :type => "AuthToken", :auth_key => "eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJrdWJlcm5ldGVzL3NlcnZpY2VhY2NvdW50Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9uYW1lc3BhY2UiOiJkZWZhdWx0Iiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZWNyZXQubmFtZSI6Im1hbmFnZWlxLXRva2VuLTN2c3FzIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQubmFtZSI6Im1hbmFnZWlxIiwia3ViZXJuZXRlcy5pby9zZXJ2aWNlYWNjb3VudC9zZXJ2aWNlLWFjY291bnQudWlkIjoiMmRkZDYwMGYtM2E0MC0xMWU1LWE3OWEtMDAxYTRhMjMxMjkwIiwic3ViIjoic3lzdGVtOnNlcnZpY2VhY2NvdW50OmRlZmF1bHQ6bWFuYWdlaXEifQ.fUxUZawGbvN6wp5Isgm0ZK-7sDFosWkcOua8ffvof2qBcjwXPTflFsFN36oULGh_Gq9gxPHyS0AY9P8s6TnVFg9dhjpGMdA0bbj0AHqFnQOiP5msjmvt10k0GZewZTCkr3r-S1cNqH9rNed7tYv28sosjUbScmNQ0skVojMnfwAzb83NGfKg9IBHZ9dCSYcE3LZYvgdzvqkq8Fr0QGd8Q7PEotfJ00nlei-8-oiVT2IhYQnwB2H6-2VvCABavMAKXKPFi_Hi_a4qHj2a_j1Xwai_Mv35MBpnhq_6tfttpaiREvymVz13bJSfxdM3mdOdRqvcJw7LL-cUOAVMuujufw").save;
EmsRefresh.refresh(prov);
'
