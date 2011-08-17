require 'pp'

class Event < ActiveRecord::Base
  # This hash configures external sources for events, by specifing the api module
  # plus the priority given to each source
  SOURCES = {
    :meetup => { :api => Meetup, :prio => 10 },
    :ical   => { :api => Ical,   :prio => 5  }
  }
  
  validates :name,       :presence => true
  validates :starts_at,  :presence => true 
  validates :location,   :presence => true 
  
  # synch events from external sources. All events are updated and the ones that 
  # don't appear in external sources anymore are removed.
  # Unless +include_past+ is set to true, events in the past are not imported and
  # existing past events are left untouched
  def self.sync_events include_past = false
    index = {}
    SOURCES.each do |source, conf|
      index_by_time_and_source(conf[:api].get_events, source, index, include_past)
    end
    
    cut_off = include_past ? Time.at(0) : Time.now
    self.destroy_all(["starts_at > ?", cut_off])
    
    index.each do |time, events_per_source|
      consolidated = consolidate(events_per_source)
      consolidated.each do |event|
        puts event.errors.full_messages.join(', ') unless event.save
      end
    end      
  end
  
  # returns a new event with attributes that are specified by the adapter object
  def self.build_from adapter
    event  = self.new
    event.attributes.keys.each do |attr|
      next unless adapter.respond_to?(attr)
      event.send("#{attr}=".to_sym, adapter.send(attr))
    end
    
    event
  end
  
  # true if two events are the same event in real life, meaning their attributes 
  # don't have to be the same necessarily. Currently the matching is done based 
  # on geo coordinates
  def same_as? other
    return unless other
    return unless self.starts_at == other.starts_at
    threshold = 10**-3
    
    self.lat and other.lat and 
      (self.lat - other.lat).abs < threshold
    (self.lon - other.lon).abs < threshold
  end
  
  # retrive the geocoordinates for this event if they are not set already
  def get_geo_coordinates
    return if self.location.blank?
    coords = GoogleGeocoding.geo_coordinates_for(self.location)
    self.lat = coords[0]
    self.lon = coords[1]
  end
  
  # merge attributes from +other+ into self if not set  
  def merge! other
    self.attributes.each do |attr, val|
      next unless val.blank?
      self.send("#{attr}=".to_sym, other.send(attr))
    end
  end
  
  
  class << self
    private 
 
    def index_by_time_and_source(events, source, index, include_past)
      raise "no events from #{source}!" if events.blank?
      events.each do |e| 
        next if !include_past and e.starts_at.to_time < Time.now
        index[e.starts_at] ||= {}
        index[e.starts_at][source] ||= []
        index[e.starts_at][source] << e
      end
    end
  
    # do a cartesian product of events from different sources and check for each
    # pair if they are the same event. If they are, merge them, giving higher prio
    # to attributes of events that come from a higher prio source
    def consolidate events_per_source
      events_sorted_by_source = events_by_prio(events_per_source)
      
      # find first non-empty batch of events in the order of prio
      begin 
        consolidated = events_sorted_by_source.shift
      end while consolidated.blank?
    
      events_sorted_by_source.each do |events|
        left_merge(consolidated, events)
      end
      consolidated
    end
    
    # merge the array of events to the right into the the array on the left.
    # Events that are the same will be merged, giving prio to values on the left,
    # Others will be added to the left array 
    def left_merge(left, right)
      un_mergable = [] 
      
      right.each do |event|
        event.get_geo_coordinates unless event.lat
        left.each do |top_prio|
          if(event.same_as? top_prio)
            top_prio.merge!(event)
          else
            un_mergable << event
          end
        end
      end
      left.concat(un_mergable)
    end
  
    # returns a nested array of events, were events form a source with higher 
    # prio come first
    def events_by_prio(events_per_source)
      @p_idx ||= SOURCES.keys.inject({}) {|hsh, s| hsh[SOURCES[s][:prio]] = s; hsh}
      @p_idx.keys.sort.reverse.collect {|prio| events_per_source[@p_idx[prio]] || [] }
    end
  end
  
end