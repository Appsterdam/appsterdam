require File.expand_path('../../../test_helper', __FILE__)

describe ClassifiedHelper do
  it "formats classified classes" do
    classified_classes(classifieds(:bike), 0).should == 'classified grid_6 twitter-box alpha offered'
    classified_classes(classifieds(:house), 1).should == 'classified grid_6 twitter-box omega wanted'
  end
end