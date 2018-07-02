ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', '..', 'app.rb')

require 'capybara'
require 'capybara/cucumber'
require 'selenium/webdriver'
require 'selenium/webdriver/common/wait'
require 'rspec'
require 'database_cleaner'
require 'database_cleaner/cucumber'


if ENV['SELENIUM_REMOTE_HOST']
  Cabybara_javascript_driver = :selenium_remote_firefox
  Capybara.register_driver "selenium_remote_firefox".to_sym do |app|
    Capybara::Selenium::Driver.new(
      app,
      browser: :remote,
      url: "http://#{ENV['SELENIUM_REMOTE_HOST']}:4444/wd/hub",
      desired_capabilities: :firefox,
    )
  end
end

DatabaseCleaner.strategy = :truncation, {:except => %w[users]}

Around do |scenario, block|
  DatabaseCleaner.cleaning(&block)
end
Capybara.server_host = '0.0.0.0'

Capybara.app_host = "http://icing-test:56555"
Capybara.server_port = "56555"

Capybara.default_driver = "selenium_remote_firefox".to_sym

Capybara.app = Icing

class IcingWorld
  include Capybara::DSL
  include RSpec::Expectations
  include RSpec::Matchers
end

World do
  IcingWorld.new
end
