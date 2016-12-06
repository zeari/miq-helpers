#!/usr/bin/env ruby

def load_rails # TODO: extract to script
  ENV['RAILS_ENV'] = ARGV[0] || 'development'
  require './config/environment'
end

# --------------------
# functions and consts
# --------------------

def push_metric (prov, timestamp, interval = "daily")
  prov.metric_rollups << MetricRollup.create(
    :capture_interval_name => interval,
    :timestamp => timestamp,
    :time_profile => TimeProfile.first,
    :cpu_usage_rate_average                   => rand(100),
    :mem_usage_absolute_average               => rand(100),
    :derived_vm_numvcpus                      => 4,
    :net_usage_rate_average                   => rand(1000),
    :derived_memory_available                 => 8192,
    :derived_memory_used                      => rand(8192),
    :stat_container_group_create_rate         => rand(100),
    :stat_container_group_delete_rate         => rand(50),
    :stat_container_image_registration_rate   => rand(25)
  )
end

def push_nodes_metric (prov, timestamp)
  prov.container_nodes.each do |node|
    node.metric_rollups << MetricRollup.create(
      :capture_interval_name      => "hourly", 
      :timestamp                  => timestamp,
      :cpu_usage_rate_average     => rand(100), 
      :mem_usage_absolute_average => rand(100), 
      :derived_vm_numvcpus        => 4, 
      :net_usage_rate_average     => rand(1000), 
      :derived_memory_available   => 8192, 
      :derived_memory_used        => rand(8192))
  end
end

def push_last_30_days(prov)
  (0 .. 30).each { |x| push_metric(prov, x.days.ago, "daily") }
end

def push_last_24_hours(prov)
  (0 .. 24).each { |x| push_metric(prov, x.hours.ago, "hourly") }
end

def push_nodes_last_24_hours(prov)
  (0 .. 24).each { |x| push_nodes_metric(prov, x.hours.ago) }
end

# --------------------
# push metric data
# --------------------

load_rails

ManageIQ::Providers::ContainerManager.all.each do |prov|
  push_last_30_days(prov)
  push_last_24_hours(prov)
  push_nodes_last_24_hours(prov)
end
