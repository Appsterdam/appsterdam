class MembersController < ApplicationController
  allow_access(:authenticated, :only => [:edit, :update, :destroy]) { member_is_current_user? }
  allow_access :all, :only => [:index, :new, :create]
  allow_access :admin

  include Twitter

  def index
    @selection = Selection.new(params)
    if @selection.empty?
      unless params[:page]
        params[:started_at_page] = params[:page] = Member.random_start_page
      end
    end
    @members = Member.where(:marked_as_spam => false).selection(@selection).order(:id).page(params[:page])
    respond_to do |format|
      format.js { render :partial => 'page', :content_type => 'text/html' }
      format.html
    end
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
    @authenticated.update_attributes(params[:member].slice(*Member::ACCESSIBLE_ATTRS))
    redirect_to edit_member_url(@authenticated)
  end

  def destroy
    if member_is_current_user?
      @authenticated.delete
      logout
      redirect_to members_url
    else
      Member.find(params[:id]).update_attribute(:marked_as_spam, true)
      redirect_to spam_markings_url
    end
  end

  private
  
  def member_is_current_user?
    @authenticated.id == Integer(params[:id])
  end

  def user_attributes
    twitter_client.info
  end
end
