require 'sinatra'
require 'mandrill'
require 'base64'
require 'rack-flash'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)

set :price,                     ENV['PRICE'] || 5000
set :session_secret, ENV['SESSION_SECRET']   || 'RandomSecret'
set :mandrill_apikey, ENV['MANDRILL_APIKEY'] || "LGi4TzBJVI5KSt9VcD6tbw"
set :publishable_key, ENV['PUBLISHABLE_KEY'] || "pk_test_nG09TMEInN07UYmCrrtjzhEU"
set :secret_key,           ENV['SECRET_KEY'] || "sk_test_lUDSPrbvMc0vOT2XbOFuSceg"
Stripe.api_key = settings.secret_key

enable :sessions
#see https://github.com/sul-dlss/sdr-services-app/blob/master/Sinatra-error-handling.md
disable :raise_errors, :show_exceptions

use Rack::Flash, sweep: true, accessorize: [:success, :error]

class SendError < StandardError
end

def charge(email:, token:, price:)
  customer = Stripe::Customer.create(:email => email, :card => token)
  Stripe::Charge.create(:amount      => price,
                        :description => 'Association app test',
                        :currency    => 'eur',
                        :customer    => customer.id)
end


def pdf(status:)
  @status = OpenStruct.new(status)
  `echo "#{erb(:pdf, layout: false)}" | bundle exec wkhtmltopdf --encoding utf8 - - 2>/dev/null`
end

def send_email(email:, key:, status:)
  api = Mandrill::API.new(key)
  api.messages.send(subject: "Your status is ready",
                    from_email: "support@association.com",
                    from_name: "Association",
                    attachments: [{type: "application/pdf;base64",
                                   name: 'status.pdf',
                                   content: Base64.encode64(pdf(status: status))}],
                    text: erb(:"mail.text"),
                    html: erb(:"mail.html"),
                    to: [{email: email}]).first.tap do |result|
    if result['status'] == 'rejected'
      raise SendError.new("Could not send the email - #{result['reject_reason']}")
    end
  end
end

helpers do
  def flashes
    %w[error success].inject({}) do |out, type|
      out.merge type => flash.send(type)
    end.delete_if{ |_, msg| msg.nil? }
  end
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
  charge(email: params[:stripeEmail],
         token: params[:stripeToken],
         price: settings.price)

  send_email(email: params[:stripeEmail],
             key: settings.mandrill_apikey,
             status: JSON.load(session[:status]))

  flash.success = "The email to #{params[:stripeEmail]} has been sent."
  redirect to('/')
end

error Stripe::StripeError do
  p(flash.error = env['sinatra.error'].message)
  redirect to('/charge')
end

error SendError do
  p(flash.error = env['sinatra.error'].message)
  redirect to('/')
end

error do
  p(flash.error = env['sinatra.error'].message)
  redirect to('/')
end
