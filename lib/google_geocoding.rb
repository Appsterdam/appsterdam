module GoogleGeocoding
  class OverApiLimit < StandardError; end
  
  # Not quite happy with this. Some searches simply won't return any results
  KNOWN_PLACES = {
    'Cafe Bax'      => [52.3655878, 4.8679774],
    'NDSM Wharf'    => [52.3730556, 4.8922222],
    'To be decided' => [nil, nil]
  }
  
  class << self
    attr_accessor :log
    
    # returns an array with [latitude, longitude] for the given address
    # if it can't be found it will return [ni, nil]
    def geo_coordinates_for address
      @log ||= Rails.logger
      return KNOWN_PLACES[address] if KNOWN_PLACES[address]
      
      google_data = get_geo_json address, :retries => 2
      location = google_data['results'].first['geometry']['location'] rescue {}
     
      log_empty(address, google_data['status']) if location.blank?
      [location['lat'], location['lng']]
    end
  
    private
    
    def log_empty(address, status)
      @log.warn "could not retreive geo coordinates for #{address}. #{status}" 
    end
  
    def get_geo_json address, options = {}
      retries = options[:retries] || 0
      json = {}
      
      response = open url_for address
      json = JSON.parse(response.read)
      
      case json['status']
      when 'OVER_QUERY_LIMIT'
        sleep 1.5
        json = get_geo_json(address, :retries => retries-1) if retries > 0
      when 'ZERO_RESULTS'
        json = get_geo_json(try_to_fix(address), :retries => retries-1) if retries > 0
      end

      json
    rescue URI::InvalidURIError 
      @log.fatal "invalid google geocoding url: #{url_for address}"
    rescue OpenURI::HTTPError
      @log.fatal "unable to retreive google geocoding data (http error) from url #{url_for address}"
    end
    
    # removing the place (as in venue) name from an address sometimes leads
    # to results
    def try_to_fix address
      parts = address.split(",")
      if parts.shift
        parts.join(',')
      else
        address
      end
    end
  
    def url_for address
      "#{api_url}?sensor=false&region=nl&address=#{CGI.escape(address)}"
    end
  
    def api_url
      "http://maps.googleapis.com/maps/api/geocode/json"
    end
  
  end
end
