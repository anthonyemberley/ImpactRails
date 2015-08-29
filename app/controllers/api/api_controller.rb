module Api
	class ApiController < ApplicationController
		respond_to :json
		before_filter :authenticate_user_from_token

		def authenticate_user_from_token
		    @user_auth_token = request.headers["API-TOKEN"].presence	#this will require tokens on headers
		    response = AuthenticateTokenService.new(@user_auth_token).perform
		    if response.success?
		    	@current_user = response.user
		    else 
		    	render status: :unauthorized, json: {
			    	errors: "Invalid Token You do not have access to this api"
			  	}
		    end 
		end
	end
end 
