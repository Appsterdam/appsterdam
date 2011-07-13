class Selection
  def self.attributes=(attrs)
    @attributes = attrs
    attr_accessor *attrs
  end
  
  def self.attributes
    @attributes
  end
  
  def initialize(params={})
    params.each do |key, value|
      setter = "#{key}="
      if respond_to?(setter) and value != 'all'
        send(setter, value)
      end
    end
  end
  
  def to_hash
    hash = ActiveSupport::HashWithIndifferentAccess.new
    self.class.attributes.each do |attribute|
      unless (value = send(attribute)).blank?
        hash[attribute] = value
      end
    end
    hash
  end
  
  alias_method :conditions, :to_hash
  
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
  
  def empty?
    to_hash.empty?
  end
end

class MemberSelection < Selection
  self.attributes = [:entity, :work_location, :work_type, :platform]

  def conditions
    as_hash    = to_hash
    conditions = as_hash.slice(*self.class.attributes[0,2])
    
    self.class.attributes[2,2].each do |attr|
      if values = as_hash[attr]
        conditions[attr.to_s + 's_as_string'] = values
      end
    end
    conditions
  end
end

class ClassifiedSelection < Selection
  self.attributes = [:offered, :category]
end
