class SpamMarking < ActiveRecord::Base
  belongs_to :member
  belongs_to :reporter, :class_name => 'Member'

  private

  validates_presence_of :member_id, :ip_address
end
