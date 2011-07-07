class Member < ActiveRecord::Base
  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
  
  def self.create_with_twitter_user(attributes)
    create(
      :twitter_id => attributes['id'],
      :name => attributes['name'],
      :username => attributes['screen_name'],
      :picture => attributes['profile_image_url'],
      :location => attributes['location'],
      :website => attributes['url'],
      :bio => attributes['description']
    )
  end
end
