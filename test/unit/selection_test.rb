require File.expand_path("../../test_helper", __FILE__)

describe "A", Selection::Member do
  it "sets it's attributes from parameters" do
    selection = Selection::Member.new('entity' => 'student')
    selection.entity.should == 'student'
  end
  
  it "ignores attributes with the value 'all'" do
    selection = Selection::Member.new('entity' => 'student', 'work_location' => 'all')
    selection.entity.should == 'student'
    selection.work_location.should.be.nil
  end
  
  it "returns a hash with the selected attributes" do
    Selection::Member.new.to_hash.should == {}
    Selection::Member.new('entity' => 'student').to_hash.should == { 'entity' => 'student' }
  end
  
  it "merges old and new facets into the selection" do
    Selection::Member.new.merge('entity' => 'developer').to_hash.should == { 'entity' => 'developer' }
    Selection::Member.new('entity' => 'student').merge('entity' => 'developer').to_hash.should == { 'entity' => 'developer' }
    Selection::Member.new('entity' => 'student').merge('work_location' => 'appsterdam').to_hash.should == { 'entity' => 'student', 'work_location' => 'appsterdam' }
  end
  
  it "ignores 'all' values when merging" do
    Selection::Member.new.merge('entity' => 'all').to_hash.should == {}
    Selection::Member.new('entity' => 'student').merge('entity' => 'all').to_hash.should == {}
  end
  
  it "knows if the selection if empty" do
    Selection::Member.new.should.be.empty
    Selection::Member.new('entity' => 'all').should.be.empty
    Selection::Member.new('entity' => 'student').should.not.be.empty
  end
  
  it "returns a hash with search conditions" do
    Selection::Member.new('entity' => 'student').conditions.should == {'entity' => 'student'}
    Selection::Member.new('work_type' => 'marketing').conditions.should == {'work_types_as_string' => 'marketing'}
    Selection::Member.new('work_type' => 'marketing', 'platform' => 'ios').conditions.should == {'work_types_as_string' => 'marketing', 'platforms_as_string' => 'ios'}
  end

  it "returns the resource name" do
    Selection::Member.new.resource_name.should == 'member'
  end
end

describe "A", Selection::Classified do
  it "sets it's attributes from parameters" do
    selection = Selection::Classified.new('category' => 'bikes')
    selection.category.should == 'bikes'
  end

  it "ignores attributes with the value 'all'" do
    selection = Selection::Classified.new('offered' => 'true', 'category' => 'all')
    selection.offered.should == 'true'
    selection.category.should.be.nil
  end

  { :to_hash => 'the selected attributes', :conditions => 'search conditions' }.each do |method, label|
    it "returns a hash with #{label}" do
      Selection::Classified.new.send(method).should == {}
      Selection::Classified.new('category' => 'bikes').send(method).should == { 'category' => 'bikes' }
    end
  end

  it "merges old and new facets into the selection" do
    Selection::Classified.new.merge('category' => 'housing').to_hash.should == { 'category' => 'housing' }
    Selection::Classified.new('category' => 'bikes').merge('category' => 'housing').to_hash.should == { 'category' => 'housing' }
    Selection::Classified.new('category' => 'housing').merge('offered' => 'false').to_hash.should == { 'category' => 'housing', 'offered' => 'false' }
  end

  it "ignores 'all' values when merging" do
    Selection::Classified.new.merge('category' => 'all').to_hash.should == {}
    Selection::Classified.new('category' => 'housing').merge('category' => 'all').to_hash.should == {}
  end

  it "knows if the selection if empty" do
    Selection::Classified.new.should.be.empty
    Selection::Classified.new('category' => 'all').should.be.empty
    Selection::Classified.new('category' => 'housing').should.not.be.empty
  end

  it "returns the resource name" do
    Selection::Classified.new.resource_name.should == 'classified'
  end
end
