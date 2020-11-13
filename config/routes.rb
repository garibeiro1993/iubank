Rails.application.routes.draw do
 
  namespace :api do
    namespace :v1 do
      post 'account_token' => 'account_token#create'
    end
  end
end
