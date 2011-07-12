require File.expand_path("../../test_helper", __FILE__)

describe "A", Selection do
  it "sets it's attributes from parameters" do
    selection = Selection.new('entity' => 'student')
    selection.entity.should == 'student'
  end
  
  it "ignores attributes with the value 'all'" do
    selection = Selection.new('entity' => 'student', 'work_location' => 'all')
    selection.entity.should == 'student'
    selection.work_location.should.be.nil
  end
  
  it "returns a hash with the selected attributes" do
    Selection.new.to_hash.should == {}
    Selection.new('entity' => 'student').to_hash.should == { 'entity' => 'student' }
  end
  
  it "merges old and new facets into the selection" do
    Selection.new.merge('entity' => 'developer').to_hash.should == { 'entity' => 'developer' }
    Selection.new('entity' => 'student').merge('entity' => 'developer').to_hash.should == { 'entity' => 'developer' }
    Selection.new('entity' => 'student').merge('work_location' => 'appsterdam').to_hash.should == { 'entity' => 'student', 'work_location' => 'appsterdam' }
  end
  
  it "ignores 'all' values when merging" do
    Selection.new.merge('entity' => 'all').to_hash.should == {}
    Selection.new('entity' => 'student').merge('entity' => 'all').to_hash.should == {}
  end
  
  it "knows if the selection if empty" do
    Selection.new.should.be.empty
    Selection.new('entity' => 'all').should.be.empty
    Selection.new('entity' => 'student').should.not.be.empty
  end
  
  it "returns a hash with search conditions" do
    Selection.new('entity' => 'student').conditions.should == {'entity' => 'student'}
    Selection.new('work_type' => 'marketing').conditions.should == {'work_types_as_string' => 'marketing'}
    Selection.new('work_type' => 'marketing', 'platform' => 'ios').conditions.should == {'work_types_as_string' => 'marketing', 'platforms_as_string' => 'ios'}
  end
end