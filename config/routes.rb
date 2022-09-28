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

  root to: 'tops#mypage'
  get 'login' , to: 'tops#login'
  get 'mypage' , to: 'tops#mypage'
  get 'top' , to: 'tops#top'
  get 'confirm' , to: 'tops#confirm'
  resources :themas do
    member do
      get 'confirm'
      get 'lock'
      resources :answers, only:[:index, :new] do
        get 'make_session'
      end
      resources :questions, only:[:update,:new]
      resources :places
    end
  end

  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
}
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
