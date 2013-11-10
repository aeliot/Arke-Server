require 'net/http'
require 'json'
require 'sinatra'
require 'logger'

class GooglePlaces < Sinatra::Application

  
  def self.getLocation (address)
    uri = URI('https://maps.googleapis.com/maps/api/place/textsearch/json')
    params = { :key => 'AIzaSyAAc16615kw98ZLpwRZhckJkhO-A55Xd-c',
      :sensor => 'true',
      :query => address.to_s.tr(" ", "+")}
    
    uri.query = URI.encode_www_form(params)
    raw = Net::HTTP.get(uri)
    #JSON.parse(raw)["results"].first["geometry"]["location"]
    parsedRaw = JSON.parse(raw)
    if(parsedRaw.present?)
      logger.info "GOOD: parsed raw"
      parsedResults = parsedRaw["results"]
      if(parsedResults.present?)
        logger.info "GOOD: results"
        geom = parsedResults.first["geometry"]
        if(geom.present?)
          logger.info "GOOD: geometry"
          loc = geom["location"]
          if(loc.present?)
            logger.info "GOOD: location"
            return loc
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
  end
end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
