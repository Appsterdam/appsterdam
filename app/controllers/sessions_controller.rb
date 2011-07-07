class SessionsController < ApplicationController
  include Twitter
  
  def new
    start_token_request(:oauth_callback => session_url)
  end
  
  def create
    process_authorization_response do
      redirect_to root_url
    end
  end
end
