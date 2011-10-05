require File.expand_path('../../test_helper', __FILE__)

describe "On the", EventsController, "a visitor" do
  before do
    controller.stubs(:twitter_client).returns(fake_twitter)
  end
  
  it "sees a list of events" do
    get :index
    status.should.be :ok
    template.should.be 'events/index'
    assert_select 'h1'
  end
end
