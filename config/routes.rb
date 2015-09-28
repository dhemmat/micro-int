Rails.application.routes.draw do
  root to: 'micro_interviews#new'
  resources :micro_interviews, only: [:show, :edit, :update, :create, :new]
  get '/micro_interviews/:id/new', to: 'micro_interviews#new'
end
