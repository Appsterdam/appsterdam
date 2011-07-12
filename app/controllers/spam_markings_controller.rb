class SpamMarkingsController < ApplicationController
  allow_access :all

  def create
    member = Member.find(params[:member_id])
    member.spam_markings.create(:reporter => @authenticated, :ip_address => request.env['REMOTE_ADDR'])
    redirect_to members_url
  end
end
