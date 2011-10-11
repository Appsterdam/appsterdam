# get your meetup API key here: http://www.meetup.com/meetup_api/key/
Appsterdam::Application.meetup_api_options = {
  :events_url => "https://api.meetup.com/2/events",
  :key        => ENV["MEETUP_KEY"],
  :group_name => "Appsterdam"
}