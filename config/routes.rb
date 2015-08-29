Rails.application.routes.draw do
   namespace :api do
      post "/signup" => "users#sign_up"
      post "/login" => "users#login"
      get "/current_user" => "users#get_current_user"
   end
end
