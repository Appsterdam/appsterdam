require File.expand_path("../../test_helper", __FILE__)

describe "A", Member do
  it "fetches profile data from twitter.com" do
    @member = Member.new
    @member.fetch_profile_data!
  end
end
