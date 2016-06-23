#!/usr/bin/env ruby

module LoadRails
  def self.load_rails(db = 'development')
    ENV['RAILS_ENV'] = db
    require './config/environment'
  end
end
