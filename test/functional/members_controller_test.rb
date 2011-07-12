require File.expand_path('../../test_helper', __FILE__)

describe "On the", MembersController, "a visitor" do
  before do
    controller.stubs(:twitter_client).returns(fake_twitter)
  end
  
  it "sees a list of members" do
    get :index
    status.should.be :ok
    template.should.be 'members/index'
    assert_select 'h1'
  end
  
  it "sees a list of members selected by work type" do
    Member.stubs(:search).with('', {:order => :id, :page => nil, :per_page => 32, :conditions => {'work_types_as_string' => 'developer'}, :match_mode => :extended}).returns(Member.page(1))
    get :index, :work_type => 'developer'
    status.should.be :ok
    template.should.be 'members/index'
    assert_select 'h1'
  end
  
  it "sees the second page of members selected by work location" do
    Member.stubs(:search).with('', {:order => :id, :page => 2, :per_page => 32, :conditions => {'work_types_as_string' => 'developer'}, :match_mode => :extended}).returns(Member.page(2))
    get :index, :work_type => 'developer', :page => 2
    status.should.be :ok
    template.should.be 'members/index'
    assert_select 'h1'
  end
  
  it "sees search result for a query" do
    Member.expects(:search).with('johnny', {:per_page => 32, :conditions => {}, :page => nil, :order => :id, :match_mode => :extended}).returns(Member.page(1))
    get :index, :q => 'johnny'
    status.should.be :ok
    template.should.be 'members/index'
    assert_select 'h1'
  end
  
  it "gets a random page number of start off with if it isn't set" do
    get :index
    request.params[:page].should.not.be.nil
  end
  
  it "uses the same start page when it was already set" do
    get :index, :page => 5
    request.params[:page].should == 5
  end
  
  it "starts the process to add herself to the listing" do
    get :new
    should.redirect_to assigns(:request_token).authorize_url
    session[:token].should.not.be.blank
    session[:token_secret].should.not.be.blank
  end
  
  it "creates a new member listing when returning from Twitter" do
    controller.twitter_client.stubs(:info).returns(user_attributes)
    lambda {
      get(:create,
        { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
        { :token => '10qt', :token_secret => 'sxji' }
      )
    }.should.differ('Member.count', +1)
    should.redirect_to edit_member_url(assigns(:member))
  end
  
  it "does not create a new member when it already exists" do
    attributes = user_attributes
    attributes['id'] = members(:developer).twitter_id
    controller.twitter_client.stubs(:info).returns(attributes)
    lambda {
      get(:create,
        { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
        { :token => '10qt', :token_secret => 'sxji' }
      )
    }.should.not.differ('Member.count')
    status.should.be :ok
    template.should.be 'members/exists'
    assert_select 'h1'
  end
  
  it "sees a failure message when authorization failed" do
    controller.twitter_client.stubs(:authorize).raises(OAuth::Unauthorized.new)
    get(:create,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    status.should.be :ok
    template.should.be 'members/unauthorized'
    assert_select 'h1'
  end

  it "does not see members that have been marked as spam" do
    get :index
    assigns(:members).map(&:name).should.not.include 'spammer'
  end

  should.require_login.get :show, :id => members(:developer)

  should.require_login.get :edit, :id => members(:developer)
  should.require_login.put :update, :id => members(:developer)
  should.require_login.delete :destroy, :id => members(:developer)

  private
  
  def user_attributes
    {
      'id' => 6922782,
      'name' => 'Helen Old',
      'screen_name' => 'helenold',
      'profile_image_url' => 'http://a2.twimg.com/profile_images/1381947723234/image.png',
      'location' => 'Amsterdam, the Netherlands',
      'url' => 'http://helenold.blogger.com',
      'description' => 'I like nitting'
    }
  end
end

describe "The", MembersController, "concerning pagination" do
  it "returns a page of member listings when requested by client-side JS" do
    get :index, :page => 2, :format => 'js'
    status.should.be :ok
    template.should.be 'members/_page'
    response.content_type.should == 'text/html'
  end

  it "stores the page at which pagination began in the params" do
    get :index
    controller.params[:started_at_page].should == controller.params[:page]
  end

  it "keeps the page at which pagination began around" do
    get :index, :page => 2, :started_at_page => 1
    controller.params[:page].should == 2
    controller.params[:started_at_page].should == 1
  end
end

describe "On the", MembersController, "a member" do
  before do
    login(members(:developer))
  end

  it "sees a form so she can update her listing" do
    get :edit, :id => @authenticated.to_param
    status.should.be :ok
    template.should.be 'members/edit'
    assigns(:authenticated).should == @authenticated
  end

  it "can update her listing" do
    put :update, :id => @authenticated.to_param, :member => { :entity => 'company', :work_location => 'appsterdam' }
    should.redirect_to members_url(:q => @authenticated.unique_query)
    @authenticated.reload.entity.should == 'company'
    @authenticated.work_location.should == 'appsterdam'
  end

  it "can't update the details that we retrieve from Twitter or its role" do
    before = @authenticated.attributes.except('updated_at')
    put :update, :id => @authenticated.to_param, :member => {
      :twitter_id => '7890', :name => 'Mister Devin', :username => 'mr_devin',
      :picture => 'http://example.local/pics/other.png', :location => 'Amsterdam',
      :website => 'new-blog.devin.local', :bio => 'I do secret stuff',
      :role => 'admin',
      :entity => 'company' # this is the only attr that actually updates
    }
    should.redirect_to members_url(:q => @authenticated.unique_query)
    @authenticated.reload.attributes.except('updated_at').should == before.merge('entity' => 'company')
  end

  it "can delete her listing" do
    lambda {
      delete :destroy, :id => @authenticated.to_param
    }.should.differ('Member.count', -1)
    Member.find_by_id(@authenticated.id).should == nil
    should.redirect_to members_url
    should.not.be.authenticated
  end

  should.disallow.get :show, :id => members(:developer)

  should.disallow.get :edit, :id => members(:designer)
  should.disallow.put :update, :id => members(:designer)
  should.disallow.delete :destroy, :id => members(:designer)
end

describe "On the", MembersController, "a newly created member" do
  before do
    login(members(:just_added))
  end
  
  it "marks itself as 'not new' when updating for the first time" do
    put :update, :id => @authenticated.to_param, :member => { :entity => 'individual' }
    @authenticated.reload.should.not.be.as_new
  end
end

describe "On the", MembersController, "an admin" do
  before do
    login(members(:admin))
  end

  it "sees an overview of one member" do
    member = Member.unscoped.find_by_name('spammer')
    get :show, :id => member.to_param
    status.should.be :ok
    template.should.be 'members/show'
    assigns(:member).should == member
  end

  it "can flag a member so that she doesn't show up in the membership listing anymore" do
    member = members(:developer)
    lambda {
      put :update, :id => member.to_param, :member => { :marked_as_spam => true }
    }.should.not.differ('SpamReport.count')
    should.redirect_to spam_reports_url
    member.reload.should.be.marked_as_spam
    Member.all.should.not.include(member)
  end

  it "can flag a member so that she shows up in the membership listing again" do
    member = Member.unscoped.find_by_name('spammer')
    put :update, :id => member.to_param, :member => { :marked_as_spam => false }
    should.redirect_to spam_reports_url
    member.reload.should.not.be.marked_as_spam
    Member.all.should.include(member)
  end

  it "deletes all spam reports when the member is unmarked as being spam" do
    member = Member.unscoped.find_by_name('spammer')
    member.spam_reports.create(:ip_address => '1.2.3.4')
    lambda {
      put :update, :id => member.to_param, :member => { :marked_as_spam => 'false' }
    }.should.differ('SpamReport.count', -1)
    member.reload.spam_reports.should.be.empty
  end
end
