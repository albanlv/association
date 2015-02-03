ENV['RACK_ENV'] ||= 'test'

require File.expand_path("../../app.rb", __FILE__)

module RackSpecHelpers
  include Rack::Test::Methods
  attr_accessor :app
end

Sinatra::Application.configure do |app|
  app.use RackSessionAccess::Middleware
end

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.disable_monkey_patching!

  config.warnings = false

  if config.files_to_run.one?
    config.default_formatter = 'doc'
  end

  config.profile_examples = 10

  config.order = :random

  config.include RackSpecHelpers

  Kernel.srand config.seed

  config.before do
    self.app = Sinatra::Application
  end
end
