#encoding: utf-8;
require 'rubygems'

# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'capybara/rspec' 
require 'capybara/rails'
require 'gift-lk'
require 'support/database_cleaner'
require 'support/login_spec_helper'
#Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
Dir[File.expand_path("core/spec/factories/*.rb", Rails.root)].each {|f| require f}
Dir[File.expand_path("auth/spec/factories/*.rb", Rails.root)].each {|f| require f}
Dir[File.expand_path("lk/spec/factories/*.rb", Rails.root)].each {|f| require f}
#FactoryGirl.find_definitions
ActionMailer::Base.delivery_method = :test
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.default_url_options[:host] = "giftb2b.ru"
Lk::Engine.load_engine_routes
RSpec.configure do |config|
  config.mock_with :rspec
  config.include Devise::TestHelpers, :type => :controller
  config.include LoginSpecHelper
  config.after(:each) do
    ActionMailer::Base.deliveries.clear
  end
end

Capybara.default_selector = :css
