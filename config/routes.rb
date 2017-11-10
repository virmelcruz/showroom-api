Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"
  resources :floors, constraints: lambda { |req| req.format == :json } do
    resources :room, constraints: lambda { |req| req.format == :json }, except: [:destroy]
  end

  resources :users, constraints: lambda { |req| req.format == :json }
  resources :authentication, constraints: lambda { |req| req.format == :json }, only: [:create]
  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
