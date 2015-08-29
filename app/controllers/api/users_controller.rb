class Api::UsersController < Api::ApiController
	USER_RESPONSE_KEY = "user"
	skip_before_filter :authenticate_user_from_token, :only => [:create, :login]

	def create
		response = CreateUserService.new(create_user_params ).perform
		if response.success?
			@current_user = response.result
			render status: :ok , json: { 
  				:result => @current_user.as_json
  			}
		else
			render status: :unauthorized, json: {
		    	errors: response.errors
		  	}
		end
	end

	def login
		response = PasswordLoginUserService.new(password_login_parms).perform
		if response.success?
			@current_user = response.result
			render status: :ok , json: { 
  				:result => @current_user.as_json
  			}
		else
			render status: :unauthorized, json: {
		    	errors: response.errors
		  	}
		end
	end

	private

	    def create_user_params 
	     	params.require(USER_RESPONSE_KEY).permit(:name,:password,:email)
	    end

	    def password_login_parms
	    	params.require(USER_RESPONSE_KEY).permit(:email,:password)
	    end
end
