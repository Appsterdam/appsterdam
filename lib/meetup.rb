#require 'open-uri'

# driver or module for importing events from www.meetup,com
module Meetup
  
  class << self
    # returns an array of unsaved Event objects
    def get_events
      events_data = Meetup.get_events_json
    
      events_data.inject([]) do |events, event_data|
        adapter = Adapter.new(event_data)
        events << Event.build_from(adapter)
      end 
    end

    private 
  
    def get_events_json
      response = open meetup_api_url
      data = JSON.parse(response.read)
      data['results']

    rescue URI::InvalidURIError 
      raise "invalid meetup api url: #{self.meetup_api_url}"
    rescue OpenURI::HTTPError
      raise "unable to retreive meetup data (http error) from url #{self.meetup_api_url}"
    end

    def meetup_api_url
      conf = Appsterdam::Application.meetup_api_options
      "#{conf[:events_url]}?key=#{conf[:key]}&group_urlname=#{conf[:group_name]}"
    end
  end
  
  class Adapter
    # Mapping from  our Event model's attributes to meetup attributes (hash keys).
    # Extra mappings can be defined here. For more complex ones, you can define
    # an instance method
    ATTR_MAPPING = {
      :name             => 'name',
      :description      => 'description',
      :url              => 'url',
      :lon              => {'venue' => 'lon'},
      :lat              => {'venue' => 'lat'},
      :fee              => {'fee' => 'amount'},
      :fee_description  => {'fee' => 'description'}
    }
    
    def initialize(data)
      @data = data
    end
    
    def starts_at
      seconds = @data['time'] / 1000.0
      Time.at(seconds)
    end
    
    # for now lets just lump venue data together as 'location'. Other APIs
    # don't provide this break down (like iCal) and we don't really need  such 
    # detailed information
    def location
      venue = @data['venue']
      return unless venue
      
      ['name','address_1','address_2','address_3','zip','city'].collect do |key|
        venue[key]
      end.compact.join(", ")
    end
    
    # generate instance methods from mappings
    ATTR_MAPPING.each do |native, api|
      if api.is_a? Hash
        key = api.keys.first
        define_method native do
          (@data[key] || {})[api[key]]
        end
      else
        define_method native do
          @data[api]
        end
      end
    end
  end
end
