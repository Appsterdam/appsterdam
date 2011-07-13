require File.expand_path('../../test_helper', __FILE__)

describe "On the", ClassifiedsController, "a visitor" do
  it "sees an overview of all classifieds" do
    get :index
    status.should.be :ok
    template.should.be 'classifieds/index'
    assigns(:classifieds).should == Classified.all
  end

  should.require_login.get :index, :show => :mine
  should.require_login.get :new
  should.require_login.post :create
  should.require_login.get :edit, :id => classifieds(:house)
  should.require_login.put :update, :id => classifieds(:house)
  should.require_login.delete :destroy, :id => classifieds(:house)
end

describe "On the", ClassifiedsController, "a member" do
  before do
    login(members(:developer))
  end

  it "sees an overview of her own ads" do
    get :index, :show => :mine
    status.should.be :ok
    template.should.be 'classifieds/index'
    assigns(:classifieds).should == [classifieds(:bike)]
  end

  it "sees a form to create a new ad" do
    get :new
    status.should.be :ok
    template.should.be 'classifieds/new'
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

  it "sees validation errors on a failed create" do
    post :create, :classified => {}
    status.should.be :ok
    template.should.be 'classifieds/new'
    assigns(:classified).should.be.invalid
  end

  it "can edit a classified ad of herself" do
    get :edit, :id => classifieds(:bike).to_param
    status.should.be :ok
    template.should.be 'classifieds/edit'
    assigns(:classified).should == classifieds(:bike)
  end

  it "can update a classified ad of herself" do
    put :update, :id => classifieds(:bike).to_param, :classified => { :offered => 'false' }
    should.redirect_to classifieds_url
    classifieds(:bike).reload.should.be.wanted
  end

  it "sees validation errors on a failed update" do
    put :update, :id => classifieds(:bike).to_param, :classified => { :description => '' }
    status.should.be :ok
    template.should.be 'classifieds/edit'
    assigns(:classified).should.be.invalid
  end

  it "can delete a classified ad of herself" do
    lambda {
      delete :destroy, :id => classifieds(:bike).to_param
    }.should.differ('Classified.count', -1)
    should.redirect_to classifieds_url
    members(:developer).classifieds.should.be.empty
  end

  should.disallow.get :edit, :id => classifieds(:house)
  should.disallow.put :update, :id => classifieds(:house)
  should.disallow.delete :destroy, :id => classifieds(:house)
end
