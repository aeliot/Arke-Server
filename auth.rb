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
      logger.info person.MailingStreet
      logger.info person.MailingStreet.class
      if person.MailingStreet.to_s.blank?
        logger.info "GAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
        latlong = {"lat" => 0, "lng" => 0}
      else
        #latlong = GooglePlaces::getLocation(person.MailingStreet.to_s)
        address = person.MailingStreet.to_s
        uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
        params = { :key => 'AIzaSyBk66EtdWPunYZZEDHnK80Uye0bjNRzV9Q',
          :sensor => 'true',
          :query => address.to_s.tr(" ", "+")}
        
        uri.query = URI.encode_www_form(params)
        raw = Net::HTTP.get(uri)
        #JSON.parse(raw)["results"].first["geometry"]["location"]                                       
        logger.info uri
        logger.info raw

        parsedRaw = JSON.parse(raw)
        if(parsedRaw.present?)
          logger.info "GOOD: parsed raw"
          parsedResults = parsedRaw["results"]
          logger.info parsedRaw
          logger.info parsedResults
          if(parsedResults.present?)
            logger.info "GOOD: results"
            geom = parsedResults.first["geometry"]
            if(geom.present?)
              logger.info "GOOD: geometry"
              loc = geom["location"]
              if(loc.present?)
                logger.info "GOOD: location"
                #return loc
              else
                logger.info "Error: location nil"
              end
            else
              logger.info "Error: geometry nil"
            end
          else
            logger.info "Error: results nil"
          end
        else
          logger.info "Error: parsed raw nil"
        end
        
      
      
        logger.info latlong
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
