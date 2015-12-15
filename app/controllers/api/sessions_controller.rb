class Api::SessionsController < Api::ApiController
	USER_RESPONSE_KEY = "user"
	FACEBOOK_RESPONSE_KEY = "facebook"
	skip_before_filter :authenticate_user_from_token, :only => [:sign_up, :login, :facebook_authentication]

	def sign_up
		response = CreateUserService.new(create_user_params).perform
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

	def facebook_authentication
		response = FacebookAuthenticationService.new(facebook_authentication_params).perform
		if response.success?
			@current_user = response.result
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def logout
		response = LogoutService.new(@current_user).perform
		if response.success?
			render_success_with_message("User has successfully logged out")
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def get_current_user
		plaid_access_token = decrypt(@current_user.encrypted_plaid_token)
		gte_date = @current_user.last_contribution_date
		response = GetTransactionsService.new(plaid_access_token, gte_date).perform
		if response.success?
			transactions = response.result
			contribution_object = CalculateContributionService.new(transactions).perform
			if contribution_object.success?
				money_accumulated_today = contribution_object.result
				@current_user.update_attribute(:pending_contribution_amount, money_accumulated_today)
			end
		elsif @current_user.pending_contribution_amount != 0
			@current_user.update_attribute(:pending_contribution_amount, 0)
		end
		render_default_user_response(@current_user)
	end 

	private

		'''PARAMS '''
	    def create_user_params 
	     	params.require(USER_RESPONSE_KEY).permit(:name,:password,:email,:device_token)
	    end

	    def password_login_parms
	    	params.require(USER_RESPONSE_KEY).permit(:email,:password,:device_token)
	    end

	    def facebook_authentication_params
	    	params.require(FACEBOOK_RESPONSE_KEY).permit(:name,:email,:facebook_id, :facebook_access_token,:device_token)
	    end

	    '''RENDER'''
	    def render_default_user_response(user)
	    	render status: :ok , json: user.as_json
		end
end
