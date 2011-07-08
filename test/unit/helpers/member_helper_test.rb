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
  
  it "formats tags about the member" do
    [
      [nil, nil, ''],
      ['', '', ''],
      [%w(), %(), ''],
      [%w(design), %w(windows-phone-7), "<ul class=\"tags\"><li>Design</li><li>Windows Phone 7</li></ul>"],
      [%w(development marketing), %w(web ios osx ), "<ul class=\"tags\"><li>Development</li><li>Marketing</li><li>The Web</li><li>iOS</li><li>Mac OS X</li></ul>"]
    ].each do |work_types, platforms, expected|
      member_tags(work_types, platforms).should == expected
    end
  end
  
  it "formates the meta information about a member" do
    [
      [stub(:available_for_hire? => false), "<div class=\"meta\"></div>"],
      [stub(:available_for_hire? => true), "<div class=\"meta\">Available for hire</div>"]
    ].each do |example, expected|
      member_meta(example).should == expected
    end
  end
end
