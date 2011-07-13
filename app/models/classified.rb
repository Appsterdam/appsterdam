class Classified < ActiveRecord::Base
  CATEGORIES = ActiveSupport::OrderedHash[[
    ['housing',    'Housing'],
    ['work_space', 'Desks and office space'],
    ['bikes',      'Bikes'],
    ['other',      'Other']
  ]]

  belongs_to :placer, :class_name => 'Member'

  # TODO this is a tmp no-op until indexing is actually added to this model
  def self.search(query, conditions)
    all
  end

  def self.purge_outdated!
    delete_all ["classifieds.created_at < ?", 30.days.ago]
  end

  def wanted?
    !offered
  end

  private

  validates_presence_of :placer_id, :category, :title, :description
  validates_inclusion_of :offered, :in => [true, false]
end
