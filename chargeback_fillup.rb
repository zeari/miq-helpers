#!/usr/bin/env ruby

# Load Rails
ENV['RAILS_ENV'] = ARGV[0] || 'development'
DIR = File.dirname(__FILE__)
require DIR + '/../manageiq/config/environment'


ContainerProject.all.each do |proj|
	(1..7).each do |x|
		proj.metric_rollups << MetricRollup.create(
		#proj.container_groups.first.metric_rollups << MetricRollup.create(
						 :timestamp => x.days.ago.utc,
						 :parent_ems_id => (proj.ems_id || proj.old_ems_id),
						 :resource_name => proj.name,
						 :cpu_usage_rate_average => 100,
						 :derived_vm_numvcpus => 1,
						 :derived_memory_used => 1,
						 :net_usage_rate_average => 1,
						 :tag_names => ["environment/dev","environment/prod"].sample,
						 :capture_interval_name => "hourly") 
#		end
	end
end

Container.all.each do |cont|
	(1..7).each do |x|
		t =  x.days.ago.utc
		cont.metric_rollups << MetricRollup.create(
						 :timestamp => t,
						 :parent_ems_id => (cont.ems_id || cont.old_ems_id),
						 :resource_name => cont.name,
						 :cpu_usage_rate_average => 100,
						 :derived_vm_numvcpus => 1,
						 :derived_memory_used => 1,
						 :net_usage_rate_average => 1,
						 :tag_names => "",
						 :capture_interval_name => "hourly") 
		state = VimPerformanceState.capture(cont)
        	state.timestamp = t
#		state.image_tag_names = ["environment/dev","environment/prod"].sample if state.image_tag_names.blank?
		state.image_tag_names = "com_redhat_component/rh_python35_docker"# if state.image_tag_names.blank?
	        state.save
	end
end
