class Member < ActiveRecord::Base
  PLATFORMS = ActiveSupport::OrderedHash[[
    ['web',             'The Web'],
    ['ios',             'iOS'],
    ['android',         'Android'],
    ['windows-phone-7', 'Windows Phone 7'],
    ['webos',           'WebOS'],
    ['osx',             'Mac OS X'],
    ['windows',         'Windows']
  ]]

  def twitter_user_attributes=(attributes)
    self.attributes = {
      :twitter_id => attributes['id'],
      :name => attributes['name'],
      :username => attributes['screen_name'],
      :picture => attributes['profile_image_url'],
      :location => attributes['location'],
      :website => attributes['url'],
      :bio => attributes['description']
    }
  end
  
  def self.create_with_twitter_user_attributes(attributes)
    member = Member.new
    member.twitter_user_attributes = attributes
    member.save
    member
  end
  
  # Returns a randomized list of members
  def self.randomized(limit=20)
    # Because the ID's might be sparse we don't know how many records we will
    # get from a query. We keep trying with a random set of ID's until we've
    # matched the desired number or of we've tried for 20 times.
    tries = 20
    randomized = Set.new
    max_id = _max_id
    while(tries > 0 && randomized.length < limit)
      tries -= 1
      samples = (1..limit).map { rand(max_id) + 1 }
      randomized.merge all(:conditions => { :id => samples })
    end
    randomized.to_a
  end

  serialize :platforms, Array

  def platforms=(platforms)
    write_attribute :platforms, platforms.reject(&:blank?)
  end

  def hiring?
    !job_offers_url.blank?
  end

  def entity=(type)
    write_attribute(:job_offers_url, nil) unless type == 'company'
    write_attribute(:available_for_hire, nil) unless %w{ student individual }.include?(type)
    write_attribute(:entity, type)
  end

  private

  def supported_platforms
    if platforms && !(invalid = platforms - PLATFORMS.keys).empty?
      errors.add(:platforms, "currently can't include #{invalid.to_sentence}")
    end
  end

  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
  validate :supported_platforms
end
