require "spec_helper"
require "rack/test"
require "capybara/rspec"

require File.expand_path("../../app", __FILE__)

Capybara.app = Sinatra::Application

module RackSpecHelpers
  include Rack::Test::Methods
  attr_accessor :app
end

RSpec.configure do |c|
  c.include RackSpecHelpers,         feature: true
  c.include Capybara::DSL,           feature: true
  c.include Capybara::RSpecMatchers, feature: true

  c.before feature: true do
    self.app = Sinatra::Application
  end
end
