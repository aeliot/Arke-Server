require 'httparty'
require 'json'


class GooglePlaces
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/place/textsearch/json'
  default_params :key => 'AIzaSyAAc16615kw98ZLpwRZhckJkhO-A55Xd-c', :sensor => 'true'
  format :json

  def self.getLocation(address)
    result = get('', :query => {:query => address.tr(" ", "+")}).parsed_response
    result["results"].first["geometry"]["location"]
  end

end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
