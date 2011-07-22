require File.expand_path('../../test_helper', __FILE__)

describe "On the", CommandsController, "a visitor" do
  it "starts a re-index" do
    FlyingSphinx::IndexRequest.expects(:cancel_jobs)
    FlyingSphinx::IndexRequest.expects(:new).returns(stub(
      :update_and_index => true,
      :status_message   => 'Done'
    ))
    post :create, :task => 'index'
  end
end