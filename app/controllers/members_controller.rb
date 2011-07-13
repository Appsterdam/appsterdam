class MembersController < ApplicationController
  allow_access(:authenticated, :only => [:edit, :update, :destroy]) { @authenticated.id == Integer(params[:id]) }
  allow_access :all, :only => [:index, :new, :create]
  allow_access :admin

  include Twitter

  def index
    @selection = MemberSelection.new(params)
    if @selection.empty? and params[:q].blank?
      unless params[:page]
        params[:started_at_page] = params[:page] = Member.random_start_page
      end
      @members = Member.order(:id).page(params[:page])
    else
      @members = Member.search(params[:q].to_s, :conditions => @selection.conditions, :order => :id, :page => params[:page], :per_page => 32, :match_mode => :extended)
    end
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
  
  def edit
    @member = @authenticated
    render @member.as_new? ? :new : :edit
  end

  def update
    accessible_attributes = Member::ACCESSIBLE_ATTRS
    
    if @authenticated.admin?
      @member = Member.unscoped.find(params[:id])
      accessible_attributes << :marked_as_spam
    else
      @member = @authenticated
    end
    
    @member.as_new = false
    if @member.update_attributes(params[:member].slice(*accessible_attributes))
      if @authenticated == @member
        redirect_to members_url(:q => @authenticated.unique_query)
      else
        redirect_to spam_reports_url
      end
    else
      render @member.as_new? ? :new : :edit
    end
  end

  def destroy
    @authenticated.delete
    logout
    redirect_to members_url
  end

  private

  def user_attributes
    twitter_client.info
  end
end
