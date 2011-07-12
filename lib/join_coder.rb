class JoinCoder < ActiveRecord::AttributeView
  def load(input)
    return [] if input.blank?
    input.split
  end

  def parse(value)
    return '' if value.blank?
    value.join(' ')
  end
end