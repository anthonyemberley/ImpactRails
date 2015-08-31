Rails.application.routes.draw do
   namespace :api do
      post "/signup" => "users#sign_up"
      post "/login" => "users#login"
      post "/facebook_auth" => "users#facebook_authentication"
      get "/current_user" => "users#get_current_user"
   end
end
