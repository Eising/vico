#!/usr/bin/env ruby
# encoding: utf-8

require "rubygems"
require "bundler"
require 'yaml'
require 'ipaddr'
require 'ostruct'

# All gem dependencies are handled through bundler
Bundler.require


class Icing < Sinatra::Base

  set :views, settings.root + '/views'

  # Flash
  enable :sessions

  configure :development do
    set :session_secret, "ASdcasd31254Qasf!%asd"
  end

  # Connect to the database
  DB = Sequel.connect("postgres://#{ENV['ICING_DB_USER']}:#{ENV['ICING_DB_PASSWORD']}@#{ENV['ICING_DB_HOST']}/#{ENV['ICING_DATABASE']}")

  DB.extension :pg_array
  DB.extension :pg_json
  Sequel.extension :pg_array_ops
  Sequel.extension :pg_json_ops


  # Check if migrations are up to date
  Sequel.extension :migration
  Sequel::Migrator.check_current(DB, "db/migrations")


  def config
    OpenStruct.new(YAML.load_file('etc/config.yml'))
  end

end

# Load all helpers

Dir[File.dirname(__FILE__) + "/helpers/*.rb"].each do |file|
  require file

end

# Load up all models next
Dir[File.dirname(__FILE__) + "/models/*.rb"].each do |file|
  require file
end

# Load up all controllers last
Dir[File.dirname(__FILE__) + "/controllers/*.rb"].each do |file|
  require file
end
