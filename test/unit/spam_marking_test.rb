require File.expand_path("../../test_helper", __FILE__)

describe SpamMarking, "concerning validation" do
  before do
    @marking = members(:developer).spam_markings.build(:ip_address => '1.2.3.4')
  end

  it "is invalid without a `member'" do
    @marking.member = nil
    @marking.should.be.invalid
    @marking.errors[:member_id].should.not.be.blank
  end

  it "is invalid without an `ip_address'" do
    @marking.ip_address = ''
    @marking.should.be.invalid
    @marking.errors[:ip_address].should.not.be.blank
  end
end

describe "A", SpamMarking do
  before do
    @marking = members(:developer).spam_markings.build(:ip_address => '1.2.3.4')
  end

  it "returns the member that's reported as being spam" do
    @marking.member.should == members(:developer)
  end

  it "returns the reporter, if there is one" do
    @marking.reporter.should == nil
    @marking.reporter = members(:designer)
    @marking.save!
    @marking.reload.reporter.should == members(:designer)
  end
end
