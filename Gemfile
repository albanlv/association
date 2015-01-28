source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'rack'
gem 'sinatra'
gem 'wkhtmltopdf-binary'
gem 'stripe',      source: 'https://code.stripe.com'
gem 'rest-client', source: 'https://code.stripe.com/'

group :production, :staging do
  gem 'thin'
end

group :development do
  gem 'pry'
  gem 'pry-doc'
  gem 'shotgun'
end

group :test, :development do
  gem 'rspec'
  gem 'capybara'
  gem 'launchy'
  gem 'rack_session_access'
  gem 'pdf-inspector', '~> 1.2.0'
end
