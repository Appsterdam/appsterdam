class SessionsController < ApplicationController
  def new
    @request_token = twitter_client.authentication_request_token(:oauth_callback => session_url)
    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end
  
  def create
    twitter_client.authorize(
      session[:token],
      session[:token_secret],
      :oauth_verifier => params[:oauth_verifier]
    )
    if twitter_client.authorized?
      login
      redirect_to root_url
    end
  rescue OAuth::Unauthorized
    render :unauthorized
  ensure
    session[:token] = nil
    session[:token_secret] = nil
  end
end
