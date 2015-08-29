Rails.application.routes.draw do
  namespace :api do
    get "/test" => "api#test"
    post "/signup" => "users#create"
    post "/login" => "users#login"
    get "/current_user" => "users#get_current_user"
  end
end
