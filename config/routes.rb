Rails.application.routes.draw do
  root to: 'interview_questions#new'
  resources :interview_questions, only: [:show, :edit, :update, :create, :new] do
    resource :response
  end
end
