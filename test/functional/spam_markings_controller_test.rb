require File.expand_path('../../test_helper', __FILE__)

share "SpamMarkingsController" do
  it "can mark a member listing as being spam" do
    lambda {
      post :create, :member_id => members(:developer).to_param
    }.should.differ("SpamMarking.count", +1)
    should.redirect_to members_url
    members(:developer).spam_markings.size.should == 1
    members(:developer).should.be.marked_as_spam
  end
end

describe "On the", SpamMarkingsController, "a vistor" do
  shared_specs_for "SpamMarkingsController"

  it "'s IP address is stored on the marking, so the admin can see if the visitor isn't a troll" do
    request.env['REMOTE_ADDR'] = '1.2.3.4'
    post :create, :member_id => members(:developer).to_param
    members(:developer).spam_markings.first.ip_address.should == '1.2.3.4'
  end
end

describe "On the", SpamMarkingsController, "a member" do
  before do
    login(members(:designer))
  end

  shared_specs_for "SpamMarkingsController"

  it "'s IP address *and* ID is stored on the marking, so the admin can see if the member isn't a troll" do
    request.env['REMOTE_ADDR'] = '1.2.3.4'
    post :create, :member_id => members(:developer).to_param
    marking = members(:developer).spam_markings.first
    marking.ip_address.should == '1.2.3.4'
    marking.reporter.should == members(:designer)
  end
end
