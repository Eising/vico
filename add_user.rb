#!/usr/bin/env ruby
require 'io/console'
require 'bundler'

Bundler.require

DB = Sequel.connect("postgres://#{ENV['ICING_DB_USER']}:#{ENV['ICING_DB_PASSWORD']}@#{ENV['ICING_DB_HOST']}/#{ENV['ICING_DATABASE']}")

# Load up all models next
Dir[File.dirname(__FILE__) + "/models/*.rb"].each do |file|
  require file
end

print "Enter username: "

username = gets.strip

print "Enter full name of user: "

realname = gets.strip

print "Enter password: "

password = STDIN.noecho(&:gets).strip
print "\n"

print "Enter access level (100 for admin): "

level = gets.strip

def hash_password(password)
  BCrypt::Password.create(password).to_s
end



Users.create(:name => username, :realname => realname, :access_level => level, :password => hash_password(password))
