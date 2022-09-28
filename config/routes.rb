Rails.application.routes.draw do
  
  resources :large_groups do
    member do
      patch 'move'
    end
  end

  resources :small_groups do
    member do
      patch 'move'
    end
  end

  resources :cards do
    member do
      patch 'move'
    end
  end

  resources :themas do
    member do
      get 'confirm'
      get 'lock'
      resources :answers, only:[:index, :new]
      resources :questions, only:[:update,:new]
      resources :places
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
