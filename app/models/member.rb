# encoding: UTF-8

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

  has_many :spam_reports, :autosave => true

  default_scope where(:marked_as_spam => false)
  scope :marked_as_spam, where(:marked_as_spam => true)

  ACCESSIBLE_ATTRS = [:entity, :work_location, :platforms, :job_offers_url, :available_for_hire, :work_types]

  extend PeijiSan
  self.entries_per_page = 32

  define_index do
    has :id
    
    indexes :name
    indexes :username
    indexes :location
    indexes :bio

    indexes :entity
    indexes :work_location
    indexes :platforms_as_string
    indexes :work_types_as_string

    has :available_for_hire, :as => :boolean

    set_property :group_concat_max_len => 8192
  end

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

  def platforms
    return [] if platforms_as_string.blank?
    platforms_as_string.split
  end
  
  def platforms=(values)
    self.platforms_as_string = values.reject(&:blank?).join(' ')
  end
  
  def work_types
    return [] if work_types_as_string.blank?
    work_types_as_string.split
  end
  
  def work_types=(values)
    self.work_types_as_string = values.reject(&:blank?).join(' ')
  end

  def admin?
    role == 'admin'
  end

  def hiring?
    !job_offers_url.blank?
  end

  def entity=(type)
    write_attribute(:job_offers_url, nil) unless type == 'company'
    write_attribute(:available_for_hire, nil) unless %w{ student individual }.include?(type)
    write_attribute(:entity, type)
  end

  def marked_as_spam=(marked_as_spam)
    write_attribute :marked_as_spam, marked_as_spam
    spam_reports.each(&:mark_for_destruction) if !read_attribute(:marked_as_spam)
  end
  
  def unique_query
    "@username #{username}"
  end

  def self.create_with_twitter_user_attributes(attributes)
    member = Member.new
    member.twitter_user_attributes = attributes
    member.save
    member
  end

  # Returns a scope with the visitor's selection
  def self.selection(selection)
    facets = %w(entity work_location)
    where(selection.to_hash.slice(*facets))
  end

  # Returns a random start page for the member index
  def self.random_start_page
    rand(page(0).page_count) + 1
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
