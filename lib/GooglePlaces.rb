require 'httparty'
require 'json'
require "sinatra/base"


class GooglePlaces
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/place/textsearch/json'
  default_params :key => 'AIzaSyAAc16615kw98ZLpwRZhckJkhO-A55Xd-c', :sensor => 'true'
  format :json

  def self.getLocation(address)
    result = get('', :query => {:query => address.tr(" ", "+")}).parsed_response
    lat = result["results"].first["geometry"]["location"]["lat"]
    lng = result["results"].first["geometry"]["location"]["lng"]
    {:lat => lat, :lng => lng}
  end

end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
