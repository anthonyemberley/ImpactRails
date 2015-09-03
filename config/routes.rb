Rails.application.routes.draw do
   namespace :api do
      post "/signup" => "sessions#sign_up"
      post "/login" => "sessions#login"
      post "/logout" => "sessions#logout"
      post "/facebook_auth" => "sessions#facebook_authentication"
      post "/create_cause" => "causes#create"
      get "/causes/category" => "causes#get_causes_from_category"
      get "/current_user" => "sessions#get_current_user"
      get "/causes/all"  => "causes#index"
   end
end
