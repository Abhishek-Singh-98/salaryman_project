Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # API routes
  post '/signup', to: 'auth#sign_up'
  post '/login', to: 'auth#login'
  delete '/logout', to: 'auth#logout'

  # Catch all other routes and serve the React app
  root "home#index"
  get '*path', to: 'home#index', constraints: ->(req) { req.format.html? }

  resources :employees, only: [:index, :show, :create, :update, :destroy]
  resources :job_titles, only: [:index]
  resources :countries, only: [:index]
  resources :salary_insights, only: [:index]
end
