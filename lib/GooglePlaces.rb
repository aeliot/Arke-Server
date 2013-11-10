require 'net/http'
require 'json'

class GooglePlaces
  
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
      parsedResults = parsedRaw["results"]
      if(parsedResults.present?)
        geom = parsedResults.first["geometry"]
        if(geom.present?)
          loc = geom["location"]
          return loc
        else
          print "Error: geometry nil"
        end
      else
        print "Error: results nil"
      end
    else
      print "Error: parsed raw nil"
    end
  end
end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
