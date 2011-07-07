class Member < ActiveRecord::Base
  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
  
  def self.create_with_twitter_user(user)
    create(
      :twitter_id => user.id,
      :name => user.name,
      :username => user.screen_name,
      :picture => user.profile_image_url,
      :location => user.location,
      :website => user.url,
      :bio => user.description
    )
  end
end
