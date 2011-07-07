Appsterdam::Application.routes.draw do
  resource :session
  
  root :to => "sessions#index"
end
