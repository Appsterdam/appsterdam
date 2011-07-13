Appsterdam::Application.routes.draw do
  match '/members/create'   => 'members#create',    :as => :create_members
  match '/session'          => 'sessions#create',   :as => :session
  match '/session/clear'    => 'sessions#clear',    :as => :clear_session
  match '/classifieds/mine' => 'classifieds#index', :as => :my_classifieds, :show => :mine

  resources :classifieds
  resources :members do
    resources :spam_reports
  end
  resource :session
  resources :spam_reports

  root :to => "members#index"
  
  if Rails.env.test?
    # It appears to be impossible to open up the routing after it was finalized without
    # it breaking very minor version of Rails, so we need to include the test routes here.
    resource :test_application do
      get :public_action
      get :private_action
      get :private_action_with_acl
    end
  end
end
