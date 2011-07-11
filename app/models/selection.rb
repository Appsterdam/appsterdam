class Selection
  ATTRIBUTES = [:entity, :work_location, :work_type, :platform]
  attr_accessor *ATTRIBUTES
  
  def initialize(params={})
    params.each do |key, value|
      setter = "#{key}="
      if respond_to?(setter) and value != 'all'
        send(setter, value)
      end
    end
  end
  
  def to_hash
    hash = {}.with_indifferent_access
    ATTRIBUTES.each do |attribute|
      unless (value = send(attribute)).blank?
        hash[attribute] = value
      end
    end
    hash
  end
  
  def merge(options={})
    merged = to_hash
    options.each do |key, value|
      if value == 'all'
        merged.delete(key)
      else
        merged[key] = value
      end
    end
    merged
  end
end