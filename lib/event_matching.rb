module EventMatching
  
  def same_as? other
    location_diff = string_similarity(self.location, other.location)
    name_diff     = string_similarity(self.name, other.name)
    
    # we give more weight to differnce in location  
    difference =  (1 * location_diff + name_diff) / 2
  end
  
  
  private
  
  def p_same(string1, string2)
    
  end
  
  # Returns a number between 0 and 1, 0 meaning not similar and 1 meaning 
  # very similars.
  # By difference we mean:
  # Min levensthein distance of each word/token of the shorter string to any word
  # in the longer string, normalized to the number of words in the shorter
  # This has the effect that:
  # * strings with same words but permutaded have a similarity of 1
  # * a string that has less words than another, but each of them can also 
  #   be found in the longer one, has a similarity of 1
  def string_similarity string1, string2
    words1 = string1.split(/,\s*|\s+/)
    words2 = string2.split(/,\s*|\s+/)
    
    shorter, longer = words1.length < words2.length ? [words1, words2] : [words2, words1] 
    
    total_dist = shorter.inject(0.0) do |total, word|
      min_dist = longer.collect {|other| Levenshtein.normalized_distance(other, word)}.min
      total +=  min_dist
    end
    
    certainty =   shorter.join.length.to_f / longer.join.length.to_f
    
    (1.0 - total_dist / shorter.length) * certainty
  end
  
  def get_geo_coordinates
    response = open "#{api_url}&#{self.location.gsub(/\s+/, '+')}"
    json = JSON.parse(response.read)
    location = json['results'].first['geometry']['location'] rescue {}
    self.lon = location['lng']
    self.lat = location['lat']
  end
  
  def api_url
    "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false"
  end
end