require File.expand_path('../../test_helper', __FILE__)

class FakeTwitter
  attr_accessor :authorized
  
  class FakeRequestToken
    attr_accessor :authorize_url, :token, :secret
  end
  
  class FakeUser
    attr_accessor :id
  end
  
  def authentication_request_token(options={})
    request_token = FakeRequestToken.new
    request_token.authorize_url = 'http://fake.twitter.com/as32df76'
    request_token.token = '10qt'
    request_token.secret = 'sxji'
    request_token
  end
  
  def authorize(token, secret, options={})
    @authorized = (options[:oauth_verifier] == 'uzpO')
  end
  
  def authorized?
    @authorized
  end
  
  def user
    if @authorized
      user = FakeUser.new
      user.id = 8273682734
      user
    end
  end
end

describe "On the", SessionsController, "a visitor" do
  before do
    controller.stubs(:twitter_client).returns(fake_twitter)
  end
  
  it "is redirected to Twitter for authentication" do
    get :new
    should.redirect_to assigns(:request_token).authorize_url
    session[:token].should.not.be.blank
    session[:token_secret].should.not.be.blank
  end
  
  it "checks the authentication after returning from Twitter" do
    get(:show,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    should.redirect_to root_url
    session[:twitter_id].should == 8273682734
  end
  
  it "forgets the request token and secret after completing the authorization step" do
    get(:show,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    session[:token].should.be.nil
    session[:token_secret].should.be.nil
  end
  
  it "sees a page explaining something went wrong after declining authorization" do
    controller.twitter_client.stubs(:authorize).raises(OAuth::Unauthorized.new)
    get(:show,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    status.should.be :ok
    template.should.be 'sessions/show'
    assert_select 'h1'
  end
  
  private
  
  def fake_twitter
    FakeTwitter.new
  end
end
