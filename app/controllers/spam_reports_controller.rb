class SpamReportsController < ApplicationController
  allow_access :all, :only => :create
  allow_access :admin

  def index
    @members = (SpamReport.all.map(&:member).compact.uniq + Member.marked_as_spam).sort_by(&:name)
  end

  def create
    member = Member.find(params[:member_id])
    member.spam_reports.create(:reporter => @authenticated, :ip_address => request.env['REMOTE_ADDR'])
    redirect_to members_url
  end
end
