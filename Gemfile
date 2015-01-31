source 'https://code.stripe.com'
source 'https://rubygems.org'

gem 'rack'
gem 'sinatra'
gem 'wkhtmltopdf-binary'
gem 'stripe',      source: 'https://code.stripe.com'
gem 'rest-client', source: 'https://code.stripe.com/'
gem 'mandrill-api'
gem 'rack-flash3'
gem 'activesupport', require: false

group :production, :staging do
  gem 'thin'
  gem 'rspec'
end

group :development do
  gem 'byebug'
  gem 'pry'
  gem 'pry-doc'
  gem 'shotgun'
end
