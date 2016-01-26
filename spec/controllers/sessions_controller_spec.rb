require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do

	describe "GET /api/current_user" do
    	it "deny someone from getting a user without token permission" do
    		get :get_current_user, {}, { "Accept" => "application/json"}
      		expect(response.status).to eq(401) 
    	end
    end

    # describe "POST /api/login" do 
    # 	it "Successfully logs someone in with correct login information" do 
		  #   params = { user: 
		  #   	{
		  #   		password: "abcd1234",
		  #     		email: "newt1@gmail.com"
		  #   	}
		  #   }
		    
    # 		post :login, params
    #         puts response
    # 		expect(response.status).to eq(200)
    # 	end
    # end

    describe "GET /api/current_user" do
    	it "Successfully log someone in with authentication token" do
    		@request.headers['AUTHENTICATION-TOKEN'] = "ZRXJpgZwMMkse48NSUfxByzSoM3pzvWDvQ"
    		get :get_current_user #, {}, { "Accept" => "application/json", "Content-Type" => "application/json", "AUTHENTICATION-TOKEN" => "ZRXJpgZwMMkse48NSUfxByzSoM3pzvWDvQ" }
    		puts response
      		expect(response.status).to eq(200) 
    	end
    end

end
