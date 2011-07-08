require File.expand_path("../../test_helper", __FILE__)

describe "A", Selection do
  it "sets it's attributes from parameters" do
    selection = Selection.new('entity' => 'student')
    selection.entity.should == 'student'
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
end