Rails.application.routes.draw do
  get 'questions/update'
  namespace :themas do
    
  end
  resources :themas do
    member do
      get 'confirm'
      get 'lock'
      resources :answers, only:[:index, :new]
      resources :questions, only:[:update,:new]
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
