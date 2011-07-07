require File.expand_path('../../test_helper', __FILE__)

describe "On the", MembersController, "a visitor" do
  before do
    controller.stubs(:twitter_client).returns(fake_twitter)
  end
  
  it "starts the process to add herself to the listing" do
    get :new
    should.redirect_to assigns(:request_token).authorize_url
    session[:token].should.not.be.blank
    session[:token_secret].should.not.be.blank
  end
  
  it "creates a new member listing when returning from Twitter" do
    controller.twitter_client.stubs(:user).returns([{'user' => user_attributes}])
    lambda {
      get(:create,
        { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
        { :token => '10qt', :token_secret => 'sxji' }
      )
    }.should.differ('Member.count', +1)
    should.redirect_to edit_member_url(assigns(:member))
  end
  
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
