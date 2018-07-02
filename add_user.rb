#!/usr/bin/env ruby
require 'io/console'
require 'bundler'
require 'optionparser'

Bundler.require

DB = Sequel.connect("postgres://#{ENV['ICING_DB_USER']}:#{ENV['ICING_DB_PASSWORD']}@#{ENV['ICING_DB_HOST']}/#{ENV['ICING_DATABASE']}")

# Load up all models next
Dir[File.dirname(__FILE__) + "/models/*.rb"].each do |file|
  require file
end
def hash_password(password)
  BCrypt::Password.create(password).to_s
end


options = {}

argparse = OptionParser.new do |opts|
  opts.banner = "Usage: #{$0}: [options]"

  opts.on("-u", "--username USERNAME", "Username to add") do |user|
    options[:name] = user
  end

  opts.on("-p", "--password PASSWORD", "Password") do |pass|
    options[:password] = hash_password(pass)
  end

  opts.on("-n", "--realname REALNAME", "Real name of the user") do |name|
    options[:realname] = name
  end

  opts.on("-e", "--email EMAIL", "Email address") do |email|
    options[:email] = email
  end

  opts.on("-l", "--access-level LEVEL", Integer, "Access Level (1..100)") do |level|
    options[:access_level] = level
  end
end

=begin
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

=end

required_options = [ :name, :realname, :password, :email, :access_level ]
argparse.parse!

valid = true
required_options.each do |key|
  if not options.has_key? key
    valid = false
  end
end

if not valid
  puts argparse
else
  if Users.where(:name => options[:name]).count > 0
    puts "User already exists"
  else
    Users.create(options)
    puts "Created user"
  end
end

#Users.create(:name => username, :realname => realname, :access_level => level, :password => hash_password(password))
