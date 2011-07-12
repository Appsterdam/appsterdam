class SpamMarkingsController < ApplicationController
  allow_access :all, :only => :create
  allow_access :admin

  def index
    @members = SpamMarking.all.map(&:member).compact.uniq
    @members.concat Member.unscoped.where(:marked_as_spam => true).all
  end

  def create
    member = Member.find(params[:member_id])
    member.spam_markings.create(:reporter => @authenticated, :ip_address => request.env['REMOTE_ADDR'])
    redirect_to members_url
  end
end
