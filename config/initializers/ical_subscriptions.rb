
# list all iCal subscriptions here. Each subscription is a hash with subscription
# options. Currently the only supported option is :url, the url where the calendar
# can be fond. Other options, like authorization options could be added in the
# future
Appsterdam::Application.ical_subscriptions = [
  {
    :url => "https://www.google.com/calendar/ical/9jedf9hpnrs5eocpnjtbmsh4u4%40group.calendar.google.com/public/full.ics"
  }
]