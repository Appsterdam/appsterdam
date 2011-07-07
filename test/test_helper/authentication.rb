module TestHelper
  module Authentication
    def login(member)
      @authenticated = member
      request.session[:twitter_id] = @authenticated.twitter_id
    end

    def logout!
      request.session[:twitter_id] = nil
    end

    def authenticated?
      !session[:twitter_id].blank?
    end
    
    def access_denied?
      response.status.to_i == 403
    end
    
    def login_required?
      #(response.status.to_i == 401) || (response.header['Location'] == new_session_url)
      response.status.to_i == 401
    end
  end
end
