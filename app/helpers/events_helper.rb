module EventsHelper
  def status_class event
    event.starts_at >= Time.now ? 'upcoming' : 'date'
  end
  
  def time_summary(event)
    str = event.starts_at.strftime("%A %b %d")
    str << " from #{event.starts_at.strftime("%H:%M")}"
    str << " till #{event.ends_at.strftime("%H:%M")}" if event.ends_at
    str
  end
  
  def timeline_header(date)
    case date 
    when Date.today    then 'Today'
    when Date.tomorrow then 'Tomorrow'
    else
      date.strftime("%A")
    end
  end
  
  def linkify(string)
    return string
    string.gsub(/\b((https?:\/\/|ftps?:\/\/|mailto:|www\.)([A-Za-z0-9\-_=%&@\?\.\/]+))\b/) do
      match = $1
      case match
      when /^www/     then  "<a href=\"http://#{match}\">#{match}</a>"
      else                  "<a href=\"#{match}\">#{match}</a>"
      end
    end
  end
  
  def link_to_event_location event
    return "unknown location" unless event.location
    url = if event.lat
      "http://maps.google.com/maps?z=17&q=loc:#{event.lat}+#{event.lon}"
    else
      "http://maps.google.com/maps?z=17&q=#{CGI.escape(event.location)}" 
    end
    
    link_to event.location, url
  end
end
