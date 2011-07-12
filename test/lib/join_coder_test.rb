require File.expand_path('../../test_helper', __FILE__)

describe "A", JoinCoder, "when loading" do
  before do
    @coder = JoinCoder.new
  end
  
  it "does not break on empty values" do
    @coder.load(nil).should == []
    @coder.load('').should == []
  end
  
  it "works" do
    @coder.load('development').should == %w(development)
    @coder.load('support-customer_service development').should == %w(support-customer_service development)
    @coder.load('development marketing design').should == %w(development marketing design)
  end
end

describe "A", JoinCoder, "when dumping" do
  before do
    @coder = JoinCoder.new
  end
  
  it "does not break on empty values" do
    @coder.dump(nil).should == ''
    @coder.dump('').should == ''
  end
  
  it "works" do
    @coder.dump([]).should == ''
    @coder.dump(%w(development)).should == 'development'
    @coder.dump(%w(support-customer_service development)).should == 'support-customer_service development'
    @coder.dump(%w(development marketing design)).should == 'development marketing design'
  end
end