class Classified < ActiveRecord::Base
  belongs_to :placer, :class_name => 'Member'

  def wanted?
    !offered
  end

  private

  validates_presence_of :placer_id, :category, :title, :description
  validates_inclusion_of :offered, :in => [true, false]
end
