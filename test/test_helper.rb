ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

$:.unshift(File.expand_path('../test_helper', __FILE__))
require 'fake_twitter'

class ActiveSupport::TestCase
  fixtures :all
  
  protected
  
  def fake_twitter
    FakeTwitter.new
  end
end
