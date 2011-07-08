require File.expand_path('../../../test_helper', __FILE__)

describe MemberHelper do
  it "formats member classes" do
    member_classes(members(:developer)).should == 'member individual'
    member_classes(members(:designer)).should == 'member individual'
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
  
  it "formats the member's plaforms" do
    [
      [nil, ''],
      ['', ''],
      [%w(), ''],
      [%w(windows-phone-7), "<ul class=\"tags\"><li>Windows Phone 7</li></ul>"],
      [%w(web ios osx ), "<ul class=\"tags\"><li>The Web</li><li>iOS</li><li>Mac OS X</li></ul>"]
    ].each do |example, expected|
      member_platforms(example).should == expected
    end
  end
end
