require File.expand_path('../../test_helper', __FILE__)

class FakeTwitter
  class FakeRequestToken
    attr_accessor :authorize_url, :token, :secret
  end
  
  def authentication_request_token(options={})
    request_token = FakeRequestToken.new
    request_token.authorize_url = 'http://fake.twitter.com/as32df76'
    request_token.token = 'iu87er56'
    request_token.secret = 'hj76df87'
    request_token
  end
end

describe "On the", SessionsController, "a visitor" do
  it "is redirected to twitter for authentication" do
    controller.stubs(:twitter_client).returns(fake_twitter)
    get :new
    should.redirect_to assigns(:request_token).authorize_url
    session[:token].should.not.be.blank
    session[:token_secret].should.not.be.blank
  end
  
  private
  
  def fake_twitter
    FakeTwitter.new
  end
end
