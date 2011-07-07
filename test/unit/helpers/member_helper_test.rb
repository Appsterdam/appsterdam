require File.expand_path('../../../test_helper', __FILE__)

describe MemberHelper do
  it "formats member classes" do
    member_classes(members(:developer)).should == 'member'
  end
  
  it "retrieves the link without the protocol from a website URL" do
    [
      [nil, ''],
      ['', ''],
      ['http://google.com', 'google.com'],
      ['https://helen.blogger.com/about', 'helen.blogger.com/about']
    ].each do |example, expected|
      member_domain(example).should == expected
    end
  end
end
