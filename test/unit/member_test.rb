require File.expand_path("../../test_helper", __FILE__)

describe Member, "concerning validation" do
  before do
    @member = members(:developer)
  end

  it "requires a twitter_id" do
    @member.should.not.validate_with(:twitter_id, nil)
    @member.should.not.validate_with(:twitter_id, '')
  end

  it "requires a unique twitter_id" do
    duplicate = Member.new(:twitter_id => @member.twitter_id)
    duplicate.should.be.invalid
    duplicate.errors[:twitter_id].should.not.be.blank
  end
end

describe Member do
  before do
    @attributes = {
      'id' => 6922782,
      'name' => 'Helen Old',
      'screen_name' => 'helenold',
      'profile_image_url' => 'http://a2.twimg.com/profile_images/1381947723234/image.png',
      'location' => 'Amsterdam, the Netherlands',
      'url' => 'http://helenold.blogger.com',
      'description' => 'I like nitting'
    }
  end
  
  it "updates a member's attributes with user data from the Twitter client" do
    member = Member.new
    member.twitter_user_attributes = @attributes
    member.twitter_id.should == @attributes['id']
    member.username.should == @attributes['screen_name']
  end
  
  it "creates a new member with user data from the Twitter client" do
    lambda {
      member = Member.create_with_twitter_user_attributes(@attributes)
      member.twitter_id.should == @attributes['id']
    }.should.differ('Member.count', +1)
  end
  
  it "returns a number of members in a randomized order" do
    (0..10).each { |index| Member.new(:twitter_id => index).save! }
    Member.stubs(:rand).returns(*Member.all.map { |m| m.id - 1 })
    
    Member.randomized(2).length.should == 2
    Member.randomized(10).length.should == 10
    
    Member.randomized.first.should.be.kind_of(Member)
  end
end

describe "A", Member do
  before do
    @member = Member.new
  end

  it "returns that the company is hiring if a job offers URL is provided" do
    @member.should.not.be.hiring
    @member.job_offers_url = 'http://jobs.example.local'
    @member.should.be.hiring
  end

  it "clears the job offers URL if a different entity type than `company' is selected" do
    @member.job_offers_url = 'http://jobs.example.local'
    @member.entity = 'student'
    @member.job_offers_url.should.be.blank
    @member.should.not.be.hiring
  end

  it "clears the `available for hire' field if a different entity type than `student` or `individual' is selected" do
    @member.attributes = { :entity => 'student', :available_for_hire => true }
    @member.should.be.available_for_hire
    @member.entity = 'company'
    @member.available_for_hire.should == nil
  end

  it "clears both the job offers URL and `available for hire' fields when selecting `group' as entity" do
    @member.attributes = {
      :job_offers_url => 'http://jobs.example.local',
      :available_for_hire => true,
      :entity => 'group'
    }
    @member.job_offers_url.should.be.blank
    @member.available_for_hire.should == nil
  end
end
