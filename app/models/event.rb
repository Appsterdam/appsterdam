require 'pp'

class Event < ActiveRecord::Base
  #include EventMatching
  SOURCES = {
    :meetup => { :api => Meetup, :prio => 10 },
    :ical   => { :api => Ical,   :prio => 5  }
  }
  
  validates :name,       :presence => true
  validates :starts_at,  :presence => true 
  validates :location,   :presence => true 
  
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
  
  
  def self.build_from adapter
    event  = self.new
    event.attributes.keys.each do |attr|
      next unless adapter.respond_to?(attr)
      event.send("#{attr}=".to_sym, adapter.send(attr))
    end
    
    event
  end
  
  def <=> other
    self.starts_at.to_time <=> other.starts_at.to_time
  end
  
  def same_as? other
    return unless other
    return unless self.starts_at == other.starts_at
    threshold = 10**-3
    
    self.lat and other.lat and 
      (self.lat - other.lat).abs < threshold
      (self.lon - other.lon).abs < threshold
  end
  
  def get_geo_coordinates
    return if self.location.blank?
    coords = GoogleGeocoding.geo_coordinates_for(self.location)
    self.lat = coords[0]
    self.lon = coords[1]
  end
  
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
      event_groups = events_by_prio(events_per_source)
      consolidated = event_groups.shift
    
      event_groups.each do |events|
        new_events = []
      
        events.each do |event|
          event.get_geo_coordinates unless event.lat
          consolidated.each do |top_prio|
            if(event.same_as? top_prio)
              puts "same event: #{event.name} -> #{top_prio.name}\n"
              top_prio.merge!(event)
            else
              new_events << event
            end
          end
        end
      
        consolidated += new_events
      end
      consolidated
    end
  
    # returns a nested array of events, were events form a source with higher 
    # prio come first
    def events_by_prio(events_per_source)
      @p_idx ||= SOURCES.keys.inject({}) {|hsh, s| hsh[SOURCES[s][:prio]] = s; hsh}
      @p_idx.keys.sort.reverse.collect {|prio| events_per_source[@p_idx[prio]] || [] }
    end
  end
  
end