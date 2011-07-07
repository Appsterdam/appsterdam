class ApplicationController < ActionController::Base
  protect_from_forgery
  
  protected
  
  # -- shared controller methods --
  
  def twitter_client
    @twitter_client ||= TwitterOAuth::Client.new(Appsterdam::Application.twitter_options)
  end
  
  def login
    session[:twitter_id] = twitter_client.user.id
  end
end
