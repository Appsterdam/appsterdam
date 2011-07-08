require File.expand_path('../../test_helper', __FILE__)

describe Batched do
  it "finds the largest ID in the table" do
    Member._max_id.should == Member.all.map(&:id).max
  end

  it "returns a list of ID's in a batch" do
    Member._ids_in_batch(0, 0).should == []

    Member._ids_in_batch(3, 0).should == [0, 1, 2]
    Member._ids_in_batch(3, 1).should == [3, 4, 5]

    Member._ids_in_batch(4, 0).should == [0, 1, 2, 3]
    Member._ids_in_batch(4, 1).should == [4, 5, 6, 7]
  end

  it "selects batches of a maximum size" do
    collection = stub('Collection')
    scope = stub('Scope')
    scope.stubs(:all).returns(collection)

    Member.stubs(:_max_id).returns(3653)
    (0..7).each do |index|
      Member.expects(:scoped).with(:conditions => { :id => Member._ids_in_batch(512, index) }).returns(scope)
    end

    Member.batched do |collection|
      collection.should == collection
    end
  end

  it "passes additional options to the finder method" do
    Member.stubs(:_max_id).returns(12)
    scope = stub('Scope')
    Member.expects(:scoped).with(:conditions => { :id => Member._ids_in_batch(512, 0) }).returns(scope)
    scope.expects(:all).with(:include => :account).returns(nil)
    Member.batched(:include => :account) {}
  end
end