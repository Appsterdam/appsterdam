require File.expand_path('../../test_helper', __FILE__)

share "SpamReportsController" do
  it "can mark a member listing as being spam" do
    lambda {
      post :create, :member_id => members(:developer).to_param
    }.should.differ("SpamReport.count", +1)
    should.redirect_to members_url
    members(:developer).spam_reports.size.should == 1
  end
end

describe "On the", SpamReportsController, "a vistor" do
  shared_specs_for "SpamReportsController"

  it "'s IP address is stored on the marking, so the admin can see if the visitor isn't a troll" do
    request.env['REMOTE_ADDR'] = '1.2.3.4'
    post :create, :member_id => members(:developer).to_param
    members(:developer).spam_reports.first.ip_address.should == '1.2.3.4'
  end

  should.require_login.get :index
end

describe "On the", SpamReportsController, "a member" do
  before do
    login(members(:designer))
  end

  shared_specs_for "SpamReportsController"

  it "'s IP address *and* ID is stored on the marking, so the admin can see if the member isn't a troll" do
    request.env['REMOTE_ADDR'] = '1.2.3.4'
    post :create, :member_id => members(:developer).to_param
    marking = members(:developer).spam_reports.first
    marking.ip_address.should == '1.2.3.4'
    marking.reporter.should == members(:designer)
  end

  should.disallow.get :index
end

describe "On the", SpamReportsController, "an admin" do
  before do
    login(members(:admin))
  end

  it "sees an overview of all membership listings reported for spam" do
    members(:developer).spam_reports.create(:ip_address => '1.2.3.4', :reporter => members(:designer))
    members(:developer).spam_reports.create(:ip_address => '4.3.2.1')

    get :index
    status.should.be :ok
    template.should.be 'spam_reports/index'
    assert_select %{form[action="#{member_path(members(:developer))}"]} do
      assert_select 'input[type=hidden][value=true]'
      assert_select 'input[type=submit][value="Remove membership listing"]'
    end
    assert_select %{form[action="#{member_path(members(:developer))}"]} do
      assert_select 'input[type=hidden][value=false]'
      assert_select 'input[type=submit][value="Unmark as spam"]'
    end
  end

  it "sees an `unmark' button for those that have been marked as spam" do
    get :index
    assert_select 'input[type=submit][value="Remove membership listing"]', :count => 0
    assert_select %{form[action="#{member_path(Member.unscoped.find_by_name('spammer'))}"]} do
      assert_select 'input[type=hidden][value=false]'
      assert_select 'input[type=submit][value="Unmark as spam"]'
    end
  end
end
