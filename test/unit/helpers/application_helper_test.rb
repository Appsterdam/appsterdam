require File.expand_path('../../../test_helper', __FILE__)

describe ApplicationHelper do
  it "figures out the page id" do
    stubs(:controller).returns(MembersController.new)
    page_id.should == 'page-members'
  end
end