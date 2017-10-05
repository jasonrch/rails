Rails.application.routes.draw do
  resources :users
  resources :teams

  resources :leagues do
    resources :teams
  end


  resources :players
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
