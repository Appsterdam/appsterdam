require File.expand_path("../../test_helper", __FILE__)

describe Member, "concerning validation" do
  before do
    @member = members(:developer)
  end

  it "requires a twitter_id" do
    @member.twitter_id = ''
    @member.should.be.invalid
    @member.errors[:twitter_id].should.not.be.blank
  end

  it "requires a unique twitter_id" do
    duplicate = Member.new(:twitter_id => @member.twitter_id)
    duplicate.should.be.invalid
    duplicate.errors[:twitter_id].should.not.be.blank
  end
end

describe Member do
  it "creates a new record with the JSON data returned by twitter.com" do
    expected = members(:developer); expected.delete
    created = Member.create_with_profile_data(File.read(fixture('TwitterAPI/users-show.json')))
    created.should == expected
  end
end

describe "A", Member do
  before do
    @member = members(:developer)
  end

  it "updates its profile data from twitter.com" do
    @member = Member.new
    @member.fetch_profile_data!
  end
end
