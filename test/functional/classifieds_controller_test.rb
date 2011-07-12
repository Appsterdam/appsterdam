require File.expand_path('../../test_helper', __FILE__)

describe "On the", ClassifiedsController, "a member" do
  before do
    login(members(:developer))
  end

  it "can post an ad" do
    lambda {
      post :create, :classified => {
        :offered => true, :category => 'bikes',
        :title => 'A great granny bike!', :description => "It's quite simply the most awesome bike in town."
      }
    }.should.differ('@authenticated.reload.classifieds.count', +1)
    should.redirect_to classifieds_url # TODO will we have a show/edit page?
    ad = members(:developer).classifieds.last
    ad.should.be.offered
    ad.category.should == 'bikes'
    ad.title.should == 'A great granny bike!'
    ad.description.should == "It's quite simply the most awesome bike in town."
  end
end
