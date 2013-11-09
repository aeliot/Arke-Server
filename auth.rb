require "sinatra/base"
require "omniauth"
require "omniauth-salesforce"
require 'databasedotcom'

class Arke < Sinatra::Base

  configure do
    enable :logging
    enable :sessions
    set :show_exceptions, false
    set :session_secret, ENV['SECRET']
  end

  use OmniAuth::Builder do
    provider :salesforce, ENV['SALESFORCE_KEY'], ENV['SALESFORCE_SECRET']
  end

  before /^(?!\/(auth.*))/ do   
    redirect '/authenticate' unless session[:instance_url]
  end


  helpers do
    def client
      @client ||= Databasedotcom::Client.new :client_id => ENV['SALESFORCE_KEY'],
      :client_secret => ENV['SALESFORCE_SECRET']
    end
  end


  get '/' do
    client.authenticate request.env['omniauth.auth']
    
    logger.info "Visited home page"
    contact_class = client.materialize("Contact")
    @contacts = Contact.all
    erb :index
  end


  get '/authenticate' do
    redirect "/auth/salesforce"
  end


  get '/auth/salesforce/callback' do
    logger.info "#{env["omniauth.auth"]["extra"]["display_name"]} just authenticated"
    credentials = env["omniauth.auth"]["credentials"]
    session['token'] = credentials["token"]
    session['refresh_token'] = credentials["refresh_token"]
    session['instance_url'] = credentials["instance_url"]
    redirect '/'
  end

  get '/auth/failure' do
    params[:message]
  end

  get '/unauthenticate' do
    session.clear 
    'Goodbye - you are now logged out'
  end

  error Force::UnauthorizedError do
    redirect "/auth/salesforce"
  end

  error do
    "There was an error.  Perhaps you need to re-authenticate to /authenticate ?  Here are the details: "
  end

  run! if app_file == $0

end
