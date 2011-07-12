class SpamMarking < ActiveRecord::Base
  belongs_to :member
  belongs_to :reporter, :class_name => 'Member'
end
