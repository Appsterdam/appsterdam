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

  it "requires the platforms to be in the available platforms list" do
    @member.platforms = %w{ web ios android windows-phone-7 webos osx windows beos }
    @member.should.be.invalid
    @member.errors[:platforms].should.not.be.blank
    @member.platforms = %w{ web ios android windows-phone-7 webos osx windows }
    @member.should.be.valid
  end

  it "requires the work types to be in the available platforms list" do
    @member.work_types = %w{ design development marketing management-executive support-customer_service dompteur }
    @member.should.be.invalid
    @member.errors[:work_types].should.not.be.blank
    @member.work_types = %w{ design development marketing management-executive support-customer_service }
    @member.should.be.valid
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
  
  it "returns a unactuated query with the visitor's selection" do
    Member.selection(Selection.new).should.be.kind_of(ActiveRecord::Relation)
    Member.selection(Selection.new).should.equal_set Member.all
  end
  
  it "returns a unactuated query with the visitor's selection for simple facets" do
    Member.selection(Selection.new('entity' => 'individual')).each do |member|
      member.entity.should == 'individual'
    end
    Member.selection(Selection.new('work_location' => 'appsterdam')).each do |member|
      member.work_location.should == 'appsterdam'
    end
  end
  
  xit "returns an unactuated query with the visitor's selection for list-like attributes" do
    Member.selection(Selection.new('platform' => 'ios')).each do |member|
      member.platforms.should.include 'ios'
    end
    Member.selection(Selection.new('work_type' => 'development')).each do |member|
      member.work_types.should.include 'development'
    end
  end
  
  it "returns a random start page to use for the member index" do
    start_page = Member.random_start_page
    start_page.should <= Member.page(0).page_count
    start_page.should > 0
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

  it "takes a list of platforms the member has experience with" do
    @member.update_attribute :platforms, %w{ web ios osx }
    @member.reload.platforms.should == %w{ web ios osx }
  end

  it "santizes the platforms input" do
    @member.platforms = ['ios', '', 'osx']
    @member.platforms.should == %w{ ios osx }
  end

  it "takes a list of work types the member has experience with" do
    @member.update_attribute :work_types, %w{ design marketing }
    @member.reload.work_types.should == %w{ design marketing }
  end

  it "sanitizes the work types input" do
    @member.work_types = ['design', 'marketing', '']
    @member.work_types.should == %w{ design marketing }
  end

  it "is marked as spam if it has at least one spam marking" do
    members(:developer).spam_markings.create(:ip_address => '1.2.3.4')
    members(:developer).should.be.marked_as_spam
  end
end
