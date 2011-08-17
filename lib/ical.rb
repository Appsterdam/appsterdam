require 'open-uri'

# driver or module for importing events from ical feeds
module Ical
  # nuber of months in the future that we generate unbound repating events for
  MONTHS_ADVANCE_FOR_REPATING = 12
  
  class << self
    # returns an array of unsaved Event objects
    def get_events
      events = []   
      Appsterdam::Application.ical_subscriptions.each do |options|
        components = parse_ical(options[:url])
        events.concat(extract_events(components.first))
      end
    
      events
    end
  
    private
  
    # takes a RiCal::Component::Calendar and extracts an array of native Event objects from it
    def extract_events(calendar)
      events = []
      rep_until = Date.today >> MONTHS_ADVANCE_FOR_REPATING
      
      calendar.events.each do |event_entry|
        # for performance reasons, create event once and then clone per occurrence
        event      = Event.build_from(Adapter.new(event_entry))
        occurences = event_entry.occurrences(:before => rep_until)  
        # again, for performance and api limit reasons, get geo coordinates for repeating
        # events only once
        event.get_geo_coordinates if occurences.size > 1
    
        occurences.each do |ical_event|
          adapter = Adapter.new(ical_event)
          occurrence = event.clone
          occurrence.starts_at = adapter.starts_at
          occurrence.ends_at   = adapter.ends_at
          events << occurrence
        end
      end
    
      events
    end
  
    def parse_ical(url)
      RiCal.parse get_ical_io(url)
    end
  
    def get_ical_io(url)
      open url 
    rescue URI::InvalidURIError 
      raise "invalid ical url: #{self.meetup_api_url}"
    rescue OpenURI::HTTPError
      raise "unable to retreive ical data (http error) from url #{self.meetup_api_url}"
    end
  end 
  
  class Adapter
    def initialize(ri_cal_event)
      @event = ri_cal_event
    end
    
    # Mapping from our Event model's attributes to RiCal Properties.
    # Extra mappings can be defined here. For more complex ones, you can define
    # an instance method
    ATTR_MAPPING = {
      :name             => :summary,
      :description      => :description,
      :starts_at        => :dtstart,
      :ends_at          => :dtend,
      :url              => :url
    }
    
    ATTR_MAPPING.each do |native, ri_cal|
      define_method native do 
        @event.send(ri_cal)
      end
    end
    
    def location
      @event.location.to_s.strip if  @event.location
    end
  end
end