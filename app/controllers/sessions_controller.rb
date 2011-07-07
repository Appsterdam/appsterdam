class SessionsController < ApplicationController
  def new
    @request_token = twitter_client.authentication_request_token(:oauth_callback => session_url)
    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end
  
  private
  
  def twitter_client
    Appsterdam::Application.twitter_client
  end
end
