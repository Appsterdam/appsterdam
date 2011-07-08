require File.expand_path('../../test_helper', __FILE__)

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
    get(:create,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    should.redirect_to root_url
    session[:twitter_id].should == 8273682734
  end
  
  it "forgets the request token and secret after completing the authorization step" do
    get(:create,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    session[:token].should.be.nil
    session[:token_secret].should.be.nil
  end
  
  it "sees a page explaining something went wrong after declining authorization" do
    controller.twitter_client.stubs(:authorize).raises(OAuth::Unauthorized.new)
    get(:create,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    status.should.be :ok
    template.should.be 'sessions/unauthorized'
    assert_select 'h1'
  end
  
  it "forgets the request token and secret after failing the authorization step" do
    controller.twitter_client.stubs(:authorize).raises(OAuth::Unauthorized.new)
    get(:create,
      { :oauth_token => 'bzLp', :oauth_verifier => 'uzpO' },
      { :token => '10qt', :token_secret => 'sxji' }
    )
    session[:token].should.be.nil
    session[:token_secret].should.be.nil
  end
  
  it "logs out when clearing the session" do
    get :clear, {}, {:twitter_id => 1234 }
    session[:twitter_id].should.be.blank
    should.redirect_to root_url
  end
  
  it "redirects back after logging out" do
    request.env["HTTP_REFERER"] = 'http://example.org/back'
    get :clear
    should.redirect_to request.env["HTTP_REFERER"]
  end
end
