module Twitter
  def start_token_request(options)
    @request_token = twitter_client.authentication_request_token(options)
    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end
  
  def process_authorization_response
    twitter_client.authorize(
      session[:token],
      session[:token_secret],
      :oauth_verifier => params[:oauth_verifier]
    )
    if twitter_client.authorized?
      login
      yield
    end
  rescue OAuth::Unauthorized
    render :unauthorized
  ensure
    session[:token] = nil
    session[:token_secret] = nil
  end
end