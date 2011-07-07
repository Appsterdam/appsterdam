require File.expand_path('../../test_helper', __FILE__)

class TestApplicationsController < ApplicationController
  allow_access :authenticated, :except => :private_action_with_acl
  allow_access :all, :only => :public_action

  def public_action
    @accessed_action = :public_action
    render :nothing => true
  end

  def private_action
    @accessed_action = :private_action
    render :nothing => true
  end

  def private_action_with_acl
    @accessed_action = :private_action_with_acl
    render :nothing => true
  end
end

describe TestApplicationsController, "concerning authentication" do
  it "always allows access to public actions" do
    get :public_action
    status.should.be :ok
    assigns(:authenticated).should == nil
    assigns(:accessed_action).should == :public_action
  end

  it "finds the user based on her twitter ID" do
    login members(:developer)
    get :private_action
    status.should.be :ok
    assigns(:authenticated).should == members(:developer)
    assigns(:accessed_action).should == :private_action
  end

  it "does not allow access to private actions without a twitter ID" do
    get :private_action
    status.should.be :unauthorized
    assigns(:authenticated).should == nil
    assigns(:accessed_action).should == nil
  end

  it "does not allow access to private actions that the user isn't authorized for" do
    login members(:developer)
    get :private_action_with_acl
    status.should.be :forbidden
    assigns(:authenticated).should == members(:developer)
    assigns(:accessed_action).should == nil
  end
end
