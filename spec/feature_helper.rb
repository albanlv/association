require "spec_helper"
require "capybara/rspec"
require 'capybara/poltergeist'
require 'rack_session_access'
require 'rack_session_access/capybara'

Capybara.app = Sinatra::Application

Capybara.javascript_driver = :poltergeist

RSpec.configure do |c|
  c.include Capybara::DSL,           feature: true
  c.include Capybara::RSpecMatchers, feature: true
end
