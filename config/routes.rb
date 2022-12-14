Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root to: 'tops#top'
  get 'login' , to: 'tops#login'
  get 'mypage' , to: 'tops#mypage'
  get 'top' , to: 'tops#top'
  get 'confirm' , to: 'tops#confirm'
  get 'about' , to: 'tops#about'

  devise_for :users, controllers: {
    registrations: "users/registrations",
    omniauth_callbacks: "users/omniauth_callbacks"
}

# #ゲスト機能
# devise_scope :user do
#   post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
#   post 'users/admin_sign_in', to: 'users/sessions#admin_sign_in'
# end

  resources :themas, except:[:index] do
    member do
      get 'confirm'
      get 'lock'
      resources :answers, only:[:index, :new] do
        get 'make_session'
      end
      resources :questions, only:[:update,:new]
      resources :places, except:[:index]
    end
  end

resources :large_groups, only:[:destroy, :update, :create] do
  member do
    patch 'move'
  end
end

resources :small_groups, only:[:destroy, :update, :create] do
  member do
    patch 'move'
  end
end

resources :cards, only:[:destroy, :update, :create] do
  member do
    patch 'move'
  end
end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
