require 'sinatra'

get '/' do
  erb :index
end

post '/' do
  response['Content-Type']        = 'application/pdf'
  response['Content-Disposition'] = 'inline'
  `echo "#{erb(:pdf, layout: false)}" | wkhtmltopdf --encoding utf8 - -`
end
