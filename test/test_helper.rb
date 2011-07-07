ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'test/spec/rails/macros'

$:.unshift(File.expand_path('../test_helper', __FILE__))
require 'fake_twitter'
require 'authentication'

class ActiveSupport::TestCase
  fixtures :all

  protected

  include TestHelper::Authentication

  def fake_twitter
    FakeTwitter.new
  end
end
