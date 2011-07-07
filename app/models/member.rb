class Member < ActiveRecord::Base
  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
end
