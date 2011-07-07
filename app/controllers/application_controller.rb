class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :find_authenticated, :block_access

  protected

  def find_authenticated
    if id = session[:twitter_id]
      @authenticated = Member.find_by_twitter_id(id)
    end
  end

  def access_forbidden
    if @authenticated
      send_response_document(:forbidden)
    else
      send_response_document(:unauthorized)
    end
  end

  # -- shared controller methods --
  
  def twitter_client
    @twitter_client ||= TwitterOAuth::Client.new(Appsterdam::Application.twitter_options)
  end
  
  def login
    session[:twitter_id] = twitter_client.info['id']
  end

  # Responds with a http status code and an error document
  def send_response_document(status)
    format = (request.format === [Mime::XML, Mime::JSON]) ? request.format : Mime::HTML
    status = Rack::Utils.status_code(status)
    send_file "#{Rails.root}/public/#{status.to_i}.#{format.to_sym}",
      :status => status,
      :type => "#{format}; charset=utf-8",
      :disposition => 'inline',
      :stream => false
  end
end
