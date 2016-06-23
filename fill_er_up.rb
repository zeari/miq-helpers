#!/usr/bin/env ruby

require_relative './load_rails'
require_relative './providers_loader'

LoadRails.load_rails

# Delete the current providers
ProvidersLoader.delete_providers

# Load providers from yaml file
ProvidersLoader.run

# Refresh the providers listed in the yaml file
ProvidersLoader.refresh_providers
