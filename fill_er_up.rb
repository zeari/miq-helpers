#!/usr/bin/env ruby

module FillErUp
  def self.load
    load_yaml[:providers].each do |hash|
      zone = Zone.find_by(:name => hash.delete(:zone))
      ExtManagementSystem.create(hash.merge(:zone => zone)) unless ExtManagementSystem.find_by(:name => hash[:name])
    end

    load_yaml[:auth_tokens].each do |hash|
      ext_name = hash[:name].split(' ', 2)[1]
      hash.merge!(:resource_id => ExtManagementSystem.find_by(:name => ext_name).try(:id))
      AuthToken.create(hash) unless AuthToken.find_by(:name => hash[:name])
    end
  end

  def self.load_yaml
    fixture_file = File.join(File.dirname(__FILE__), "fill_er_up.yaml")
    if File.exist?(fixture_file)
      YAML.load_file(fixture_file)
    else
      {}
    end
  end
end

def load_rails # TODO: extract to script
  ENV['RAILS_ENV'] = ARGV[0] || 'development'
  require './config/environment'
end

load_rails
FillErUp.load
