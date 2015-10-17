require 'rails_helper'

RSpec.describe Api::SessionsController, type: :controller do
	describe "GET /api/current_user" do
    	it "deny someone from getting a user without token permission" do
    		get :get_current_user, {}, { "Accept" => "application/json" }
      		expect(response.status).to eq 401
    	end
    end
end
