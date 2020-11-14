Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
      post 'account_token' => 'account_token#create'
      resources :accounts, only: %i[show create] do
        get 'current', on: :collection
      end
    end
  end
end
