class Selection
  ATTRIBUTES = [:entity]
  attr_accessor *ATTRIBUTES
  
  def initialize(params={})
    params.each do |key, value|
      setter = "#{key}="
      if respond_to?(setter)
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
    to_hash.merge(options)
  end
end