#!/bin/bash

bundle exec rails runner '
prov = ExtManagementSystem.first

prov.metric_rollups << MetricRollup.create(
:capture_interval_name => "daily",  
:timestamp => 1.day.ago.utc,
:time_profile => TimeProfile.first,
 :cpu_usage_rate_average => rand(100), 
 :mem_usage_absolute_average => rand(100), 
 :derived_vm_numvcpus        => 4, 
 :net_usage_rate_average     => rand(1000), 
 :derived_memory_available   => 8192, 
 :derived_memory_used        => rand(8192))

prov.metric_rollups << MetricRollup.create(
:capture_interval_name => "daily",  
:timestamp => 2.days.ago.utc,
:time_profile => TimeProfile.first,
 :cpu_usage_rate_average => rand(100), 
 :mem_usage_absolute_average => rand(100), 
 :derived_vm_numvcpus        => 4, 
 :net_usage_rate_average     => rand(1000), 
 :derived_memory_available   => 8192, 
 :derived_memory_used        => rand(8192))


prov.metric_rollups << MetricRollup.create(
:capture_interval_name => "hourly", 
:timestamp => 2.hours.ago.utc,
:time_profile => TimeProfile.first,
:tag_names => "environment/prod",
 :cpu_usage_rate_average => rand(100), 
 :mem_usage_absolute_average => rand(100), 
 :derived_vm_numvcpus        => 4, 
 :net_usage_rate_average     => rand(1000), 
 :derived_memory_available   => 8192, 
 :derived_memory_used        => rand(8192))

prov.metric_rollups << MetricRollup.create(
:capture_interval_name => "hourly", 
:timestamp => 1.hour.ago.utc,
:time_profile => TimeProfile.first,
:tag_names => "environment/prod",
 :cpu_usage_rate_average => rand(100), 
 :mem_usage_absolute_average => rand(100), 
 :derived_vm_numvcpus        => 4, 
 :net_usage_rate_average     => rand(1000), 
 :derived_memory_available   => 8192, 
 :derived_memory_used        => rand(8192))

prov.container_nodes.each do |x|
x.metric_rollups << MetricRollup.create(
:capture_interval_name => "hourly", 
:timestamp => 1.hour.ago.utc,
 :cpu_usage_rate_average => rand(100), 
 :mem_usage_absolute_average => rand(100), 
 :derived_vm_numvcpus        => 4, 
 :net_usage_rate_average     => rand(1000), 
 :derived_memory_available   => 8192, 
 :derived_memory_used        => rand(8192))
end
#ContainerNode.first.perf_capture('realtime')
#ContainerNode.first.perf_rollup(Time.now.utc.beginning_of_hour.iso8601, "hourly")


'
