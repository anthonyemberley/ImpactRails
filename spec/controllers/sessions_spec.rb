RSpec.describe "Sessions API", :type => :controller do
	describe "GET /current_user" do
    	it "deny someone from getting a user without token permission" do
    		get "/current_user", {}, { "Accept" => "application/json" }
      		expect(response.status).to eq :unauthorized
    	end
    end
end