require File.expand_path('../../test_helper', __FILE__)
require File.expand_path("../../test_helper/fake_meetup_data", __FILE__)

describe Meetup do
  before do
    Meetup.stubs(:get_events_json).returns(FAKE_MEETUP_DATA)
  end
  
  it "corectly imports events from meetup" do
    events = Meetup.get_events
    events.size.should == 4
    
    #events.sort!.each {|e| e.attributes.each {|a,v| puts "#{a}: #{v}"}; puts "\n"}
    
    event = events[0] 
    event.name.should            == "NDSM Werf Hangout"
    event.starts_at.should       == Time.local(2011, 8, 2, 9, 30, 0.0)
    event.ends_at.should         == nil
    event.location.should        == nil
    event.lon.should             == nil
    event.lat.should             == nil
    event.fee.should             == nil
    event.fee_description.should == nil
    #event.description.should     == very long :)
    
    event = events[1]  
    event.name.should            == "Weekly Meeten en Drinken Delft"
    event.starts_at.should       == Time.local(2011, 8, 3, 19, 00, 0.0)
    event.ends_at.should         == nil
    event.location.should        == 'Cafe Belvedere, Beestenmarkt, Delft'
    event.lon.should             == 4.362763
    event.lat.should             == 52.01128
    event.fee.should             == nil
    event.fee_description.should == nil
    event.description.should     == "<br \/>"
    
    event = events[2]  
    event.name.should            == "Weekly Meeten en Drinken"
    event.starts_at.should       == Time.local(2011, 8, 3, 19, 00, 0.0)
    event.ends_at.should         == nil
    event.location.should        == 'Cafe Bax, Ten Katestraat 119, Amsterdam'
    event.lon.should             == 4.867978
    event.lat.should             == 52.365589
    event.fee.should             == 1000
    event.fee_description.should == "This shit ain't cheap!"
    event.description.should     == "<p>Join Appsterdam for a weekly Meeten en Drinken at Caf&eacute; Bax, 19.00h.<\/p>\n"
    

  end

 
end