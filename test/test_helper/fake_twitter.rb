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
  
  def info
    { 'id' => 8273682734 }
  end
end