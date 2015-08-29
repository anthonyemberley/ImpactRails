class Api::UsersController < Api::ApiController
	USER_RESPONSE_KEY = "user"
	skip_before_filter :authenticate_user_from_token, :only => [:create, :login]

	def sign_up
		response = CreateUserService.new(create_user_params ).perform
		if response.success?
			@current_user = response.result
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def login
		response = PasswordLoginUserService.new(password_login_parms).perform
		if response.success?
			@current_user = response.result
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def get_current_user
		render_default_user_response(@current_user)
	end 

	private

		'''PARAMS '''
	    def create_user_params 
	     	params.require(USER_RESPONSE_KEY).permit(:name,:password,:email)
	    end

	    def password_login_parms
	    	params.require(USER_RESPONSE_KEY).permit(:email,:password)
	    end

	    '''RENDER'''
	    def render_default_user_response(user)
	    	render status: :ok , json: { 
  				:result => user.as_json
  			}
		end

	    def render_error(status,errors) 
	    	render status: status, json: {
		    	errors: errors
		  	}
	    end
end
