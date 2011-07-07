class MembersController < ActionController::Base
  def new
    @request_token = twitter_client.authentication_request_token(:oauth_callback => members_url)
    session[:token] = @request_token.token
    session[:token_secret] = @request_token.secret
    redirect_to @request_token.authorize_url
  end
end