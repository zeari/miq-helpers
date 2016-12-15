#!/usr/bin/env ruby

module LoadRails
  def self.load_rails(db = nil)
    # For DB use the method variable or environment variable or 'development'
    ENV['RAILS_ENV'] = db || ENV['RAILS_ENV'] || 'development'

    # If not in development environment, try the production directory
    begin
      require './config/environment'
    rescue LoadError
      require '/var/www/miq/vmdb/config/environment'
    end
  end
end
