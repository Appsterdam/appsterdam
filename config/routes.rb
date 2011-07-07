Appsterdam::Application.routes.draw do
  resources :members
  resource :session
  
  root :to => "sessions#index"
end
