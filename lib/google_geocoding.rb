module GoogleGeocoding
  
  # returns an array with [latitude, longitude] for the given address
  # if it can't be found it will return [ni, nil]
  def self.geo_coordinates_for address
    google_data = get_geo_json address
    location = google_data['results'].first['geometry']['location'] rescue {}
    p google_data['results']
    [location['lat'], location['lng']]
  end
  
  private
  
  def self.get_geo_json address
    response = open url_for address
    JSON.parse(response.read)
  rescue URI::InvalidURIError 
    puts "invalid google geocoding url: #{url_for address}"
  rescue OpenURI::HTTPError
    puts "unable to retreive google geocoding data (http error) from url #{url_for address}"
  end
  
  def self.url_for address
    address = "Ten Katestraat 119, 1053 CC Amsterdam, Netherlands" if address == 'Cafe Bax'
    "#{api_url}?sensor=false&region=nl&address=#{CGI.escape(address)}"
  end
  
  def self.api_url
    "http://maps.googleapis.com/maps/api/geocode/json"
  end
end
