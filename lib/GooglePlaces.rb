require 'httparty'
require 'json'


class GooglePlaces
  include HTTParty
  base_uri 'https://maps.googleapis.com/maps/api/place/textsearch/'
  default_params :key => 'AIzaSyAAc16615kw98ZLpwRZhckJkhO-A55Xd-c', :sensor => 'true'
  format :json

  def self.getLocation(address)
    result = JSON.parse(get('json', :query => address.tr(" ", "+"))
    result["results"].first["geometry"]["location"]
  end

end


def genLocations(client)
#  contact_class = client.materialize("Contact")
#  emptyContacts = Contact.find_by_MailingLatitude(0)
end
