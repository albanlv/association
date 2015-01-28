require 'sinatra'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

set :publishable_key, ENV['PUBLISHABLE_KEY'] || "pk_test_nG09TMEInN07UYmCrrtjzhEU"
set :secret_key, ENV['SECRET_KEY'] || "sk_test_lUDSPrbvMc0vOT2XbOFuSceg"
Stripe.api_key = settings.secret_key

set :price, ENV['PRICE'] || 5000
set :session_secret, ENV['SESSION_SECRET'] || 'RandomSecret'

enable :sessions

def charged?(session)
  session[:email] && !session[:email].empty?
end

get '/' do
  erb :index
end

post '/' do
  session[:status] = params[:status].to_json
  redirect to('/charge')
end

get '/charge' do
  erb :charge
end

post '/charge' do
  customer = Stripe::Customer.create(:email => params[:stripeEmail],
                                     :card  => params[:stripeToken])

  Stripe::Charge.create(:amount      => settings.price,
                        :description => 'Association app test',
                        :currency    => 'eur',
                        :customer    => customer.id)

  session[:email] = params[:stripeEmail]
  redirect to('/pdf')
end

get '/pdf' do
  redirect to('/') unless charged?(session)

  @status = OpenStruct.new(JSON.load(session[:status]))
  session[:email] = nil

  response['Content-Type']        = 'application/pdf'
  response['Content-Disposition'] = 'inline'
  `echo "#{erb(:pdf, layout: false)}" | bundle exec wkhtmltopdf --encoding utf8 - - 2>/dev/null`
end

error Stripe::StripeError do
  p(session[:error] = env['sinatra.error'].message)
end
