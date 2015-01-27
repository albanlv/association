source 'https://rubygems.org'

gem 'rack'
gem 'sinatra'
gem 'wkhtmltopdf-binary'

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
  gem 'rack-test'
  gem 'pdf-inspector', '~> 1.2.0'
end
