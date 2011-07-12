require File.expand_path("../../test_helper", __FILE__)

describe "A", SpamMarking do
  before do
    @marking = members(:developer).spam_markings.build
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
