require File.expand_path('../../../test_helper', __FILE__)

describe ApplicationHelper do
  it "figures out the page id" do
    stubs(:controller).returns(MembersController.new)
    page_id.should == 'page-members'
  end

  it "formats facet links for the current selection" do
    facet_links(MemberSelection.new, :entity, ActiveSupport::OrderedHash[[
      ['all',        'all members'],
      ['company',    'companies'],
      ['student',    'students'],
      ['individual', 'individuals', ],
      ['group',      'groups']
    ]]).should == "<a href=\"#\">all members</a><ul><li><a href=\"/members\">all members</a></li><li><a href=\"/members?entity=company\">companies</a></li><li><a href=\"/members?entity=student\">students</a></li><li><a href=\"/members?entity=individual\">individuals</a></li><li><a href=\"/members?entity=group\">groups</a></li></ul>"

    facet_links(MemberSelection.new(:entity => 'student'), :entity, ActiveSupport::OrderedHash[[
      ['all',        'all members'],
      ['company',    'companies'],
      ['student',    'students'],
      ['individual', 'individuals', ],
      ['group',      'groups']
    ]]).should == "<a href=\"#\">students</a><ul><li><a href=\"/members\">all members</a></li><li><a href=\"/members?entity=company\">companies</a></li><li><a href=\"/members?entity=student\">students</a></li><li><a href=\"/members?entity=individual\">individuals</a></li><li><a href=\"/members?entity=group\">groups</a></li></ul>"
  end
end
