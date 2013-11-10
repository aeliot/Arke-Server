require "sinatra/base"
require "omniauth"
require "omniauth-salesforce"
require 'databasedotcom'
require File.join(File.dirname(__FILE__), 'lib/GooglePlaces')

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

  get '/' do
    redirect '/authenticate' unless session[:instance_url]

    client = Databasedotcom::Client.new :client_id => ENV['SALESFORCE_KEY'], 
    :client_secret => ENV['SALESFORCE_SECRET'], 
    :host => "login.salesforce.com"
    
    client.authenticate :token => session['token'], 
    :instance_url => session['instance_url']

    logger.info "Visited home page"
    contact_class = client.materialize("Contact")
    contacts = Contact.all

    locations = Array.new
    contacts.each do |person|
      if person.MailingStreet == ""
        latlong = {"lat" => 0, "lng" => 0}
      else
        latlong = GooglePlaces::getLocation(person.MailingStreet)
      end
      
      if latlong == nil
        latlong = {"lat" => 0, "lng" => 0}
      end

      locations.push({:name => person.Name, 
                       :address => person.MailingStreet, 
                       :lat => latlong["lat"], 
                       :lng => latlong["lng"]})
    end
    @entrys = locations
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


  error do
    "Adam has fucked up again! "
  end

  run! if app_file == $0

end
