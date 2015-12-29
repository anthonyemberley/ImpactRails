require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do

	describe "GET /api/current_user" do
    	it "deny someone from getting a user without token permission" do
    		get :get_current_user, {}, { "Accept" => "application/json"}
      		expect(response.status).to eq(401) 
    	end
    end

    describe "POST /api/login" do 
    	it "Successfully logs someone in with correct login information" do 
		    params = { user: 
		    	{
		    		password: "abcd1234",
		      		email: "test@gmail.com"
		    	}
		    }
		    puts params
    		post :login, params
    		expect(response.status).to eq(200)
    	end
    end

    # describe "GET /api/current_user" do
    # 	it "Successfully log someone in with authentication token" do
    # 		request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Token.encode_credentials("CAoW43q3AZ5bc476gRyxqMbqjydjvCL_Uw")
    # 		get :get_current_user, {}, { "Accept" => "application/json", "Content-Type" => "application/json", "AUTHENTICATION-TOKEN" => "CAoW43q3AZ5bc476gRyxqMbqjydjvCL_Uw" }
    # 		puts response.status
    #   		expect(response.status).to eq(200) 
    # 	end
    # end

end
