require 'sinatra'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

get '/' do
  erb :index
end

post '/' do
  response['Content-Type']        = 'application/pdf'
  response['Content-Disposition'] = 'inline'
  `echo "#{erb(:pdf, layout: false)}" | bundle exec wkhtmltopdf --encoding utf8 - -`
end
