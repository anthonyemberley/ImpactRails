Rails.application.routes.draw do
   namespace :api do
      post "/signup" => "sessions#sign_up"
      post "/login" => "sessions#login"
      post "/logout" => "sessions#logout"
      post "/facebook_auth" => "sessions#facebook_authentication"
      get "/current_user" => "sessions#get_current_user"
   end
end
