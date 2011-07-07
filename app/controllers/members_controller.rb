class MembersController < ApplicationController
  include Twitter
  
  def index
    @members = Member.all
  end
  
  def new
    start_token_request(:oauth_callback => members_url)
  end
  
  def create
    process_authorization_response do
      @member = Member.create_with_twitter_user(user_attributes)
      if @member.errors.empty?
        redirect_to edit_member_url(@member)
      else
        @member = Member.find_by_twitter_id(user_attributes['id'])
        render :exists
      end
    end
  end
  
  private
  
  def user_attributes
    twitter_client.info
  end
end