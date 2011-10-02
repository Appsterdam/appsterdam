require File.expand_path('../../test_helper', __FILE__)

describe "On the", ArticlesController, "a visitor" do
  it "sees all the articles" do
    get :index
    status.should.be :ok
    template.should.be 'articles/index'
    assigns(:articles).should == Article.all
  end

  it "shouldn't see her articles" do
    get :index, :show => :mine
    status.should.be :unauthorized
  end

  it "shouldn't destroy an article" do
    post :destroy, :id => 1
    status.should.be :unauthorized
  end
end

describe "On the", ArticlesController, "a member" do
  before do
    login(members(:developer))
  end

  it "sees all her articles" do
    get :index, :show => :mine
    status.should.be :ok
    template.should.be 'articles/index'
    assigns(:articles).should == [articles(:article_from_developer)]
  end

  it "destroys her article" do
    post :destroy, :id => 1
    status.should.be :found
  end

  it "shouldn't destroy other member's article" do
    post :destroy, :id => 2
    status.should.be :forbidden
  end
end
