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
    get :index, :work_type => 'developer'
    status.should.be :ok
    template.should.be 'members/index'
    assert_select 'h1'
  end
  
  it "sees the second page of members selected by work location" do
    get :index, :work_type => 'developer', :page => 2
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

describe "The", MembersController, "concerning an AJAX reques" do
  it "returns a page of member listings without the layout" do
    get :index, :page => 2, :format => 'js'
    status.should.be :ok
    template.should.be 'members/_page'
    response.content_type.should == 'text/html'
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
    should.redirect_to edit_member_url(@authenticated)
    @authenticated.reload.entity.should == 'company'
    @authenticated.work_location.should == 'appsterdam'
  end

  it "can't update the details that we retrieve from Twitter" do
    before = @authenticated.attributes.except('updated_at')
    put :update, :id => @authenticated.to_param, :member => {
      :twitter_id => '7890', :name => 'Mister Devin', :username => 'mr_devin',
      :picture => 'http://example.local/pics/other.png', :location => 'Amsterdam',
      :website => 'new-blog.devin.local', :bio => 'I do secret stuff',
      :entity => 'company' # this is the only attr that actually updates
    }
    should.redirect_to edit_member_url(@authenticated)
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

  should.disallow.get :edit, :id => members(:designer)
  should.disallow.put :update, :id => members(:designer)
  should.disallow.delete :destroy, :id => members(:designer)
end
