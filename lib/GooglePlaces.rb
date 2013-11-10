require 'net/http'
require 'json'
require 'sinatra'
require 'logger'

use Rack::Logger

helpers do
  def logger
    request.logger
  end
end

def self.getLocation (address)
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
    if(parsedRaw["status"] == "OK")
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
            latlong = loc
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
      logger.info "Error: Google API " + parsedRaw["status"]
    end
  else
    logger.info "Error: parsed raw nil"
  end
  
  
  
  logger.info latlong
  return latlong
  
end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
