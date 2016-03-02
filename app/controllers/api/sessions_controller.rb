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
			render status: :ok, json: @current_user.as_json
		else
			render_error(:unauthorized, response.errors)
		end
	end


	def get_current_user
		plaid_access_token = @current_user.plaid_token
		gte_date = @current_user.updated_at
		response = GetTransactionsService.new(plaid_access_token, gte_date).perform
		if response.success?
			transactions = response.result
			contribution_object = CalculateContributionService.new(transactions).perform
			if contribution_object.success?
				money_accumulated_since_last_contribution = contribution_object.result
				@current_user.increment!(:pending_contribution_amount, money_accumulated_since_last_contribution)
			end
		else
			render_error(:unauthorized, response.errors)
			return
		end
		render_full_user_response(@current_user)
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
	    	user_response = user.as_json
	    	user_response["needs_bank_information"] = user.plaid_token.blank?
	    	user_response["needs_credit_card_information"] = user.stripe_customer_id.blank?
	    	render status: :ok , json: user_response
		end

		def render_full_user_response(user)
			user_response = user.as_json
	    	user_response["needs_bank_information"] = user.plaid_token.blank?
	    	user_response["needs_credit_card_information"] = user.stripe_customer_id.blank?
	    	#card_info = GetStripeCardsService.new(user).perform
	    	render status: :ok , json: user_response
		end
end
