Rails.application.routes.draw do

  get 'sessions/create'

  root 'home#index'

  get '/auth/github', as: :github_login
  get '/auth/github/callback', to: 'sessions#create'
  delete '/auth/github/destroy', to: 'sessions#destroy', as: :logout

end
