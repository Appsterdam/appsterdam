class Classified < ActiveRecord::Base
  CATEGORIES = ActiveSupport::OrderedHash[[
    ['housing',    'Housing'],
    ['work_space', 'Desks and office space'],
    ['bikes',      'Bikes'],
    ['other',      'Other']
  ]]

  belongs_to :placer, :class_name => 'Member'

  def wanted?
    !offered
  end

  private

  validates_presence_of :placer_id, :category, :title, :description
  validates_inclusion_of :offered, :in => [true, false]
end
