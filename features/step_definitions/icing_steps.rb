
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

Given /^(?:|I )create a service called "([^\"]*)" containing:/ do |name, fields|
  # Create template first
  step %{I am on the template compose page}
  step %{I fill in "name" with "#{name}_template"}
  step %{I fill in "description" with "A cucumber template"}
  step %{I fill in "platform" with "cucumber"}
  contents = ""
  fields.rows_hash.each do |varname, value|
    contents += "{{#{varname}}}\n"
  end
  step %{I fill in "up_contents" with "#{contents}"}
  step %{I fill in "down_contents" with "#{contents}"}
  step %{I press "Add template"}
  fields.rows_hash.each do |varname, value|
    step %{I select "No validation" from "tag.#{varname}"}
  end
  step %{I press "Submit"}
  # I configure a form
  step %{I am on the form compose page}
  step %{I fill in "name" with "#{name}"}
  step %{I select "#{name}_template" from "templates[]"}
  step %{I press "Submit"}
  fields.rows_hash.each do |varname, value|
    step %{I fill in "name.#{varname}" with "#{value}"}
  end
  step %{I press "Submit"}
end


When /^(?:|I )want to see the current page$/ do
  print page.html
end

Given /^(?:|I )create an inventory called "([^\"]*)" containing:/ do |name, fields|
  step %{I am on the add inventories page}
  step %{I fill in "name" with "#{name}"}

  fields.headers.each do |field|
    step %{I fill in "fieldname" with "#{field}"}
    step %{I press "Add Field"}
  end

  step %{I press "Submit"}

  headers = [ fields.headers ]
  data = fields.rows

  inventory = data.map(&headers.first.method(:zip)).map(&:to_h)

  # Now we need to find the Inventory
  visit(get_inventory_path(name))

  inventory.each do |opts|
    opts.each do |key, value|
        step %{I fill in "key.#{key}" with "#{value}"}
    end
    step %{I press "Add"}
  end
end

Given /^(?:|I )delete the row containing "([^\"]*)" on inventory "([^\"]*)"$/ do |field, inventory|
  step %{I go to the inventory called "#{inventory}"}
  node = find('td', text: /#{field}/)
  parent = node.find(:xpath, '..')
  parent.find_button("Delete").click
end

When /^(?:|I )delete the inventory "([^\"]*)"$/ do |name|
  step %{I go to the inventories page}
  node = find('td', text: /#{name}/)
  parent = node.find(:xpath, '..')
  id = parent.find('td', text: /^\d+$/).text
  if id
    visit("/inventories/delete/#{id}")
  else
    raise
  end

end
