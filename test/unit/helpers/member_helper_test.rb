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
      [stub(:entity => nil, :available_for_hire? => false, :work_location => nil, :job_offers_url => nil),
        nil],
      [stub(:entity => 'individual', :available_for_hire? => false, :work_location => 'applander', :job_offers_url => nil),
        "<div class=\"meta\">An individual close to Appsterdam</div>"],
      [stub(:entity => 'company', :available_for_hire? => true, :work_location => 'appsterdammer', :job_offers_url => nil),
        "<div class=\"meta\">A company<br>Available for hire</div>"],
        [stub(:entity => 'company', :available_for_hire? => true, :work_location => 'applander', :job_offers_url => 'http://example.org/hiring'),
          "<div class=\"meta\">A company close to Appsterdam<br>Available for hire<br><a href=\"http://example.org/hiring\">We're hiring</a></div>"]
    ].each do |example, expected|
      member_meta(example).should == expected
    end
  end
  
  it "does not allow junk to be filled out for the job offer url" do
    [
      nil,
      '',
      'example.org',
      '../../../phpadmin.php',
      'skype://112'
    ].each do |offer_url|
      member_meta(stub(:entity => nil, :available_for_hire? => false, :work_location => nil, :job_offers_url => offer_url)).should.be.nil
    end
  end
  
  it "formats facet links for the current selection" do
    member_facet_links(Selection.new, :entity, ActiveSupport::OrderedHash[[
      ['all',        'all members'],
      ['company',    'companies'],
      ['student',    'students'],
      ['individual', 'individuals', ],
      ['group',      'groups']
    ]]).should == "<a href=\"#\">all members</a><ul><li><a href=\"/members?entity=all\">all members</a></li><li><a href=\"/members?entity=company\">companies</a></li><li><a href=\"/members?entity=student\">students</a></li><li><a href=\"/members?entity=individual\">individuals</a></li><li><a href=\"/members?entity=group\">groups</a></li></ul>"
    
    member_facet_links(Selection.new(:entity => 'student'), :entity, ActiveSupport::OrderedHash[[
      ['all',        'all members'],
      ['company',    'companies'],
      ['student',    'students'],
      ['individual', 'individuals', ],
      ['group',      'groups']
    ]]).should == "<a href=\"#\">students</a><ul><li><a href=\"/members?entity=all\">all members</a></li><li><a href=\"/members?entity=company\">companies</a></li><li><a href=\"/members?entity=student\">students</a></li><li><a href=\"/members?entity=individual\">individuals</a></li><li><a href=\"/members?entity=group\">groups</a></li></ul>"
  end
end
