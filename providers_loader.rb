#!/usr/bin/env ruby

module ProvidersLoader
  # Create new providers using the yaml fixture file
  def self.run
    load_yaml[:providers].to_a.each do |hash|
      create_ems(hash)
    end
  end

  # Create and save a new ExtManagementSystem
  def self.create_ems(hash)
    unless ExtManagementSystem.find_by(:name => hash[:name])
      hash.update(:zone => Zone.find_by(:name => 'default'))

      ExtManagementSystem.create(hash)
    end
  end

  # Load the fixture file
  def self.load_yaml(filename = 'fill_er_up.yaml')

    fixture_file = File.join(File.dirname(__FILE__), filename)
    YAML.load_file(fixture_file) if File.exist?(fixture_file)
  end

  # Refresh providers using the yaml fixture file
  def self.refresh_providers
    load_yaml[:providers].to_a.each do |hash|
      ems = ExtManagementSystem.find_by(:name => hash[:name])
      EmsRefresh.refresh(ems)
    end
  end

  # Delete all providers from database
  def self.delete_providers
    ManageIQ::Providers::Kubernetes::ContainerManager.destroy_all
    ManageIQ::Providers::Openshift::ContainerManager.destroy_all
  end
end
