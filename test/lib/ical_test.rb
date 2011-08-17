require File.expand_path('../../test_helper', __FILE__)

describe Ical do
  before do
    @fake_ical = File.open(File.expand_path('../../test_helper/fake_ical_data', __FILE__))
    
    Ical.stubs(:get_ical_io).returns(@fake_ical)
    GoogleGeocoding.stubs(:geo_coordinates_for).returns([nil, nil])
  end
  
  it "correctly imports events from ical subscription" do
    events = Ical.get_events
    events = events.sort_by {|e| e.starts_at}
    
    rep_until = (Date.today >> Ical::MONTHS_ADVANCE_FOR_REPATING).to_time 
    # the first entry is a weekly repeating event
    num_weeks = ((rep_until- events[0].starts_at) / 1.week).to_f.ceil
    num_non_repeating = 5 # change this if test ical data changes
    events.size.should == num_weeks + num_non_repeating
    
    event = events[0] 
    event.name.should            == "Appsterdam Delft Meeten en Drinken"
    event.starts_at.should       == Time.local(2011, 7, 27, 19, 00, 0.0)
    event.ends_at.should         == Time.local(2011, 7, 27, 20, 00, 0.0)
    event.location.should        == "Belvédère, Beestenmarkt 8, 2611 GB Delft"
    event.lon.should             == nil
    event.lat.should             == nil
    event.fee.should             == nil
    event.fee_description.should == nil
    
    event = events[1] 
    event.name.should            == "Appsterdam Delft Meeten en Drinken"
    event.starts_at.should       == Time.local(2011, 8, 3, 19, 00, 0.0)
    event.ends_at.should         == Time.local(2011, 8, 3, 20, 00, 0.0)
    event.location.should        == "Belvédère, Beestenmarkt 8, 2611 GB Delft"
    event.lon.should             == nil
    event.lat.should             == nil
    event.fee.should             == nil
    event.fee_description.should == nil
    
    event = events[2] 
    event.name.should            == "#rbxday (Rubinius, Ruby)"
    event.starts_at.should       == Time.local(2011, 8, 5)
    event.ends_at.should         == Time.local(2011, 8, 6)
    event.location.should        == "80beans, Vijzelstraat 72, Amsterdam"
    event.lon.should             == nil
    event.lat.should             == nil
    event.fee.should             == nil
    event.fee_description.should == nil    
  end

 
end