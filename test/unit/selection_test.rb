require File.expand_path("../../test_helper", __FILE__)

describe "A", MemberSelection do
  it "sets it's attributes from parameters" do
    selection = MemberSelection.new('entity' => 'student')
    selection.entity.should == 'student'
  end
  
  it "ignores attributes with the value 'all'" do
    selection = MemberSelection.new('entity' => 'student', 'work_location' => 'all')
    selection.entity.should == 'student'
    selection.work_location.should.be.nil
  end
  
  it "returns a hash with the selected attributes" do
    MemberSelection.new.to_hash.should == {}
    MemberSelection.new('entity' => 'student').to_hash.should == { 'entity' => 'student' }
  end
  
  it "merges old and new facets into the selection" do
    MemberSelection.new.merge('entity' => 'developer').to_hash.should == { 'entity' => 'developer' }
    MemberSelection.new('entity' => 'student').merge('entity' => 'developer').to_hash.should == { 'entity' => 'developer' }
    MemberSelection.new('entity' => 'student').merge('work_location' => 'appsterdam').to_hash.should == { 'entity' => 'student', 'work_location' => 'appsterdam' }
  end
  
  it "ignores 'all' values when merging" do
    MemberSelection.new.merge('entity' => 'all').to_hash.should == {}
    MemberSelection.new('entity' => 'student').merge('entity' => 'all').to_hash.should == {}
  end
  
  it "knows if the selection if empty" do
    MemberSelection.new.should.be.empty
    MemberSelection.new('entity' => 'all').should.be.empty
    MemberSelection.new('entity' => 'student').should.not.be.empty
  end
  
  it "returns a hash with search conditions" do
    MemberSelection.new('entity' => 'student').conditions.should == {'entity' => 'student'}
    MemberSelection.new('work_type' => 'marketing').conditions.should == {'work_types_as_string' => 'marketing'}
    MemberSelection.new('work_type' => 'marketing', 'platform' => 'ios').conditions.should == {'work_types_as_string' => 'marketing', 'platforms_as_string' => 'ios'}
  end
end

describe "A", ClassifiedSelection do
  it "sets it's attributes from parameters" do
    selection = ClassifiedSelection.new('category' => 'bikes')
    selection.category.should == 'bikes'
  end

  it "ignores attributes with the value 'all'" do
    selection = ClassifiedSelection.new('offered' => 'true', 'category' => 'all')
    selection.offered.should == 'true'
    selection.category.should.be.nil
  end

  { :to_hash => 'the selected attributes', :conditions => 'search conditions' }.each do |method, label|
    it "returns a hash with #{label}" do
      ClassifiedSelection.new.send(method).should == {}
      ClassifiedSelection.new('category' => 'bikes').send(method).should == { 'category' => 'bikes' }
    end
  end

  it "merges old and new facets into the selection" do
    ClassifiedSelection.new.merge('category' => 'housing').to_hash.should == { 'category' => 'housing' }
    ClassifiedSelection.new('category' => 'bikes').merge('category' => 'housing').to_hash.should == { 'category' => 'housing' }
    ClassifiedSelection.new('category' => 'housing').merge('offered' => 'false').to_hash.should == { 'category' => 'housing', 'offered' => 'false' }
  end

  it "ignores 'all' values when merging" do
    ClassifiedSelection.new.merge('category' => 'all').to_hash.should == {}
    ClassifiedSelection.new('category' => 'housing').merge('category' => 'all').to_hash.should == {}
  end

  it "knows if the selection if empty" do
    ClassifiedSelection.new.should.be.empty
    ClassifiedSelection.new('category' => 'all').should.be.empty
    ClassifiedSelection.new('category' => 'housing').should.not.be.empty
  end
end
