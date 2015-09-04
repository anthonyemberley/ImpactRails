Rails.application.routes.draw do
   namespace :api do
   	  '''Session'''
      post "/signup" => "sessions#sign_up"
      post "/login" => "sessions#login"
      post "/logout" => "sessions#logout"
      post "/facebook_auth" => "sessions#facebook_authentication"
      post "/create_cause" => "causes#create"
      get "/current_user" => "sessions#get_current_user"

      '''Causes '''
      post "/create_cause" => "causes#create"
      get "/causes/all"  => "causes#index"
      get "/causes/:id" => "causes#get"
      get "/causes/category" => "causes#get_causes_from_category"
      post "causes/:id/join" => "causes#join"

      '''Users '''
      get "/current_user/causes" => "causes#get_user_causes"
      post "/current_user/causes/leave" => "users#leave_current_cause"

      '''Plaid '''
      post "/plaid/create" => "plaid_api#create_plaid_user"
      put "/plaid/update" => "plaid_api#update_plaid_user"
      post "/plaid/answer" => "plaid_api#answer_security_question"
      get "/plaid/transactions" => "plaid_api#get_transactions"

   end
end
