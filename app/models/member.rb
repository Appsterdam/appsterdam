class Member < ActiveRecord::Base
  ENTITIES = ActiveSupport::OrderedHash[[
    ['company',    'Company'],
    ['student',    'Student'],
    ['individual', 'Individual'],
    ['group',      'Group (user group, non-profit collective, etc.)']
  ]]

  WORK_LOCATIONS = ActiveSupport::OrderedHash[[
    ['appsterdam', 'I work in or nearby Amsterdam (you’re an Appsterdammer)'],
    ['applander',  'I work somewhere else, but close enough to participate in events (you’re an Applander)'],
    ['appbroader', 'I work elsewhere in the world (you’re an Appbroader)']
  ]]

  PLATFORMS = ActiveSupport::OrderedHash[[
    ['web',             'The Web'],
    ['ios',             'iOS'],
    ['android',         'Android'],
    ['windows-phone-7', 'Windows Phone 7'],
    ['webos',           'WebOS'],
    ['osx',             'Mac OS X'],
    ['windows',         'Windows']
  ]]

  WORK_TYPES = ActiveSupport::OrderedHash[[
    ['design',                   'Design'],
    ['development',              'Development'],
    ['marketing',                'Marketing'],
    ['management-executive',     'Management / Executive'],
    ['support-customer_service', 'Support / Customer service']
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
  def platforms=(value)
    write_attribute :platforms, value.reject(&:blank?)
  end

  serialize :work_types, Array
  def work_types=(value)
    write_attribute :work_types, value.reject(&:blank?)
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
    check_that_elements_are_allowed :platforms, PLATFORMS.keys, platforms
  end

  def supported_work_types
    check_that_elements_are_allowed :work_types, WORK_TYPES.keys, work_types
  end

  def check_that_elements_are_allowed(attr, allowed, actual)
    if actual && !(invalid = actual - allowed).empty?
      errors.add(attr, "currently can't include #{invalid.to_sentence}")
    end
  end

  validates_presence_of :twitter_id
  validates_uniqueness_of :twitter_id
  validate :supported_platforms, :supported_work_types
end
