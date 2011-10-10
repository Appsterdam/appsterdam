class EventsController < ApplicationController
  allow_access :all
  
  def index
    now = Time.now
    @events = Event.find :all, 
      :conditions => ["starts_at >= ?", now.beginning_of_day],
      :order => 'starts_at',
      :limit => 5
    
   @events_per_day = @events.inject({}) do |idx, event|
     day = event.starts_at.to_date
     idx[day] ||= []
     idx[day] << event
     event.get_geo_coordinates unless event.lat
     idx
   end
  end
  
  def show
    @event = Event.find(params[:id])
  end
end
