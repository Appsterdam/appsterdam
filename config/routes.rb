Appsterdam::Application.routes.draw do
  match '/members' => 'members#create'
  resources :members
  resource :session
  
  root :to => "sessions#index"
end
