module AuthenticationTestHelper
  def login(member)
    @authenticated = member
    request.session[:twitter_id] = @authenticated.twitter_id
  end

  def logout!
    request.session[:twitter_id] = nil
  end
end
