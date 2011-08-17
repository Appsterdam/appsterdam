require File.expand_path("../../test_helper", __FILE__)

describe Event do
  before do
    # some exsisting events
    @past_event = Event.create( :name => "Appsterdam Delft Meeten en Drinken",
      :location  => "Belvédère, Beestenmarkt 8, 2611 GB Delft",
      :starts_at => Time.local(2011, 7, 26, 19, 00, 0.0),
      :lon       =>  4.36218,
      :lat       => 52.01178
    )
    
    @tomorrow = Date.tomorrow
    @next_week = @tomorrow + 1.week 
    
    #ical
    @ical_events = []
    @ical_events << Event.new( :name => "Appsterdam Delft Meeten en Drinken",
      :location  => "Belvédère, Beestenmarkt 8, 2611 GB Delft",
      :starts_at => @tomorrow - 1.week,
      :lon       => 4.3622053,
      :lat       => 52.0116043
    )
    @ical_events << Event.new( :name => "Appsterdam Delft Meeten en Drinken",
      :location  => "Belvédère, Beestenmarkt 8, 2611 GB Delft",
      :starts_at => Time.local(@tomorrow.year, @tomorrow.month, @tomorrow.day, 19, 00, 0.0),
      :lon       => 4.3622053,
      :lat       => 52.0116043,
      :description => "foo"
    )
      
    @ical_events << Event.new( :name => "Appsterdam Amsterdam Meeten en Drinken",
      :location  => "Cafe Bax",
      :starts_at => Time.local(@tomorrow.year, @tomorrow.month, @tomorrow.day, 19, 00, 0.0),
      :lon       =>  4.8679774,
      :lat       => 52.3655878
    )
    
    # meetup
    @meetup_events = []
    @meetup_events << Event.new(:name => "Weekly Meeten en Drinken Delft",
      :location  => 'Cafe Belvedere, Beestenmarkt, Delft',
      :starts_at => Time.local(@tomorrow.year, @tomorrow.month, @tomorrow.day, 19, 00, 0.0),
      :lon       => 4.362763,
      :lat       => 52.01128
    )
    
    @meetup_events << Event.new(:name => "Weekly Meeten en Drinken Delft",
      :location  => 'Cafe Belvedere, Beestenmarkt, Delft',
      :starts_at => Time.local(@next_week.year, @next_week.month, @next_week.day, 19, 00, 0.0),
      :lon       => 4.362763,
      :lat       => 52.01128
    )
    
    Ical.stubs(:get_events).returns(@ical_events)
    Meetup.stubs(:get_events).returns(@meetup_events)
  end
  
  it "should correcty import events" do
    Event.count.should == 1
    Event.sync_events
    Event.count.should == 4
    @events = Event.find :all, :order => 'starts_at, name'
    
    @events[0].name     == "Appsterdam Delft Meeten en Drinken"
    @events[0].location == "Belvédère, Beestenmarkt 8, 2611 GB Delft"
    @events[0].starts_at.should == Time.local(2011, 7, 26, 19, 00, 0.0)
    
    @events[2].name.should == "Weekly Meeten en Drinken Delft"
    @events[2].location.should == 'Cafe Belvedere, Beestenmarkt, Delft'
    @events[2].description.should == 'foo'
    @events[2].starts_at.should == Time.local(@tomorrow.year, @tomorrow.month, @tomorrow.day, 19, 00, 0.0)
  end
  
  
  it "should correcty import including past events" do
    Event.count.should == 1
    Event.sync_events
    Event.count.should == 5
    @events = Event.find :all, :order => 'starts_at, name'
    
    @events[0].name     == "Appsterdam Delft Meeten en Drinken"
    @events[0].location == "Belvédère, Beestenmarkt 8, 2611 GB Delft"
    @events[0].starts_at.should == @tomorrow - 1.week
  end
  
  
  
end

describe Event, "concerning validation" do 
  before do 
    @event = Event.new :name => "Event 1",
      :location  => 'Location 1',
      :starts_at => Time.now
  end
  
  it "requires a name" do
    @event.name = nil
    @event.should.be.invalid
    @event.errors[:name].should.not.be.blank
  end
  
  it "requires a start time" do
    @event.starts_at = nil
    @event.should.be.invalid
    @event.errors[:starts_at].should.not.be.blank
  end
  
  it "requires a location" do
    @event.location = nil
    @event.should.be.invalid
    @event.errors[:location].should.not.be.blank
  end
end

describe "A", Event do 
  before do 
    time = Time.now
    @e1 = Event.new :name => "Event 1",
      :location  => 'Location 1',
      :starts_at => time,
      :lon       => 4.868032336235046,
      :lat       => 52.365603101261776

    @e2 = Event.new :name => "Event 1",
      :location  => 'Location 2',
      :starts_at => time,
      :description => "Description 2"
  end
  
  
  it "should correctly merge with another event" do
    @e1.merge!(@e2)
    @e1.name.should        == "Event 1"
    @e1.location.should    == "Location 1"
    @e1.description.should == "Description 2"
  end
  
  it "should identify same events" do    
    @e2.lon = 4.867866039276123
    @e2.lat = 52.36569154303944
    @e2.should.be.same_as?(@e1)
    
    @e1.lon = 4.3622053
    @e1.lat = 52.0116043
  
    @e2.lon = 4.362763
    @e2.lat = 52.01128
    
    @e2.should.be.same_as?(@e1)
  end
  
  # coordinates can be obtained here http://www.europe-camping-guide.com/get-longitude-latitude-google-maps/
  it "should discern different events" do  
    @e2.lon = 4.869319796562195
    @e2.lat = 52.36623856787802
    @e2.should.not.be.same_as?(@e1)
  end
  
  it "not match events with different times" do  
    @e2.lon = 4.867866039276123
    @e2.lat = 52.36569154303944
    @e2.starts_at = Time.now+1.minute
    @e2.should.not.be.same_as?(@e1)
  end
end