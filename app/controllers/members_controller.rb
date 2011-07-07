class MembersController < ApplicationController
  def new
    @request_token = twitter_client.authentication_request_token(:oauth_callback => members_url)
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
      @member = Member.create_with_twitter_user(user_attributes)
      if @member.errors.empty?
        redirect_to edit_member_url(@member)
      else
        @member = Member.find_by_twitter_id(user_attributes['id'])
        render :exists
      end
    end
  rescue OAuth::Unauthorized
    render :unauthorized
  ensure
    session[:token] = nil
    session[:token_secret] = nil
  end
  
  private
  
  def user_attributes
    twitter_client.user.first['user']
  end
end