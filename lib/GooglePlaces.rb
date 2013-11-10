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
    JSON.parse(raw)["results"].first["geometry"]["location"]
  end
end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
