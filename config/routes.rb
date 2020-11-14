Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'account_token' => 'account_token#create'
      resources :transfers, only: %i[create]
      resources :accounts, only: %i[show create]
    end
  end
end
