
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^(?:|I )am logged in as (.+) with password (.+)$/ do |user, password|
  visit path_to("the login page")
  fill_in("username", :with => user)
  fill_in("password", :with => password)
  click_button("Login")
end

Given /^(?:|I )delete the template called (.+)$/ do |name|
  visit("/templates")
  id = nil
  node = find('td', text: /#{name}/)
  parent = node.find(:xpath, '..')
  id = parent.find('td', text: /^\d+$/).text
  if id
    visit("/template/delete/#{id}")
  else
    raise
  end
end


Given /^(?:|I )delete the form called (.+)$/ do |name|
  visit("/forms")
  id = nil
  node = find('td', text: /#{name}/)
  parent = node.find(:xpath, '..')
  id = parent.find('td', text: /^\d+$/).text
  if id
    visit("/forms/delete/#{id}")
  else
    raise
  end
end



When /^(?:|I )want to see the current page$/ do
  print page.html
end
