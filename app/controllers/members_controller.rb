class MembersController < ApplicationController
  allow_access(:authenticated, :only => [:edit, :update]) { @authenticated.id == Integer(params[:id]) }
  allow_access :all, :only => [:index, :new, :create]

  include Twitter
  
  def index
    @members = Member.randomized
    @selection = Selection.new(params)
  end
  
  def new
    start_token_request(:oauth_callback => create_members_url)
  end
  
  def create
    process_authorization_response do
      @member = Member.create_with_twitter_user_attributes(user_attributes)
      if @member.errors.empty?
        redirect_to edit_member_url(@member)
      else
        @member = Member.find_by_twitter_id(user_attributes['id'])
        render :exists
      end
    end
  end

  def update
    @authenticated.update_attributes(params[:member])
    redirect_to edit_member_url(@authenticated)
  end

  private
  
  def user_attributes
    twitter_client.info
  end
end
