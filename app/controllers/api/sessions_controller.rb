class Api::SessionsController < Api::ApiController
	USER_RESPONSE_KEY = "user"
	FACEBOOK_RESPONSE_KEY = "facebook"
	skip_before_filter :authenticate_user_from_token, :only => [:sign_up, :login, :facebook_authentication, :reset_password]

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
		puts "pass: " + params[:user][:password]
		response = PasswordLoginUserService.new(password_login_parms).perform
		if response.success?
			@current_user = response.result
			render_default_user_response(@current_user)
		else
			render_error(:unauthorized,response.errors)
		end
	end

	def reset_password
		email = params[:email]

		user = User.find_by(email: email)

		if user.present?
	      	PasswordResetMailer.password_reset(user).deliver_now
	      
	      	 respond_to do |format|
		     	        format.json { render json: "Sent Email? TODO: fix response here", status: :created, location: "yeez" }

		    	end
	      	
	 
	        #format.html { redirect_to(@user, notice: 'User was successfully created.') }
	   

		else
			render_error(:unauthorized, "no user with this email")
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
		gte_date = @current_user.last_contribution_date
		response = GetTransactionsService.new(plaid_access_token, gte_date, @current_user).perform
		if response.success?
			transactions = response.result
			contribution_object = CalculateContributionService.new(transactions).perform
			if contribution_object.success?
				money_accumulated_since_last_contribution = contribution_object.result
				if @current_user.automatic_donations && money_accumulated_since_last_contribution > 0
					pay(money_accumulated_since_last_contribution)
				else
					@current_user.increment!(:pending_contribution_amount, money_accumulated_since_last_contribution)
				end
			
			end
		else
			render_error(:unauthorized, response.errors)
			return
		end
		render_full_user_response(@current_user)
	end 

	def pay(amount)
		'''Check if user has current active payment, create one if not'''
		puts "here1"
		no_current_payment = @current_user.current_payment_id.nil?
		if no_current_payment
			payment_response = CreatePaymentService.new(@current_user).perform
			if payment_response.failure?
				render_error(:bad_request,payment_response.errors)
			end
		end
		puts "here2"

		'''Save Contribution '''
		if !can_make_payment?(amount)
			return
		end
				puts "here3"

		contribution_response = ContributionService.new(amount,@current_user).perform #STUB!
		if contribution_response.failure? 
			render_error(:bad_request,contribution_response.errors)
			return
		end
		puts "SAVE CONTRIBUTION SUCCESSFUL"
		contribution = contribution_response.result

		'''Update User and Cause Relationship (amount contributed to cause) '''
		user_cause_response = UpdateUserCauseService.new(@current_user,contribution.amount).perform #STUB!
		if user_cause_response.failure?
			render_error(:bad_request,user_cause_response.errors)
			return
		end
		puts "here4"

		'''Update User and its active payment '''
		user_payment_response = UpdateUserPaymentService.new(@current_user,contribution).perform #STUB!
		if user_payment_response.failure?
			render_error(:bad_request,user_payment_response.errors)
			return
		end
		puts "here5"

		'''Check if payment is above threshold, if it is then we create a stripe charge '''
		payment = user_payment_response.result
		if payment.amount > PAYMENT_THRESHOLD
			charge_response = CreateStripeChargeService.new(@current_user,payment).perform
			if charge_response.failure?
				render_error(:bad_request,charge_response.errors)
				return
			end
			render status: :ok , json: charge_response.result.as_json
			return
		end
		render status: :ok, json: contribution.as_json
	end


	def can_make_payment?(amount)
		
		if @current_user.stripe_customer_id.blank?
			render_error(:bad_request,"You cannot contribute until you have provided your credit card information")
			return false
		end
		if @current_user.plaid_token.blank?
			render_error(:bad_request,"You cannot contribute until you have provided your credit card information")
			return false
		end
		if @current_user.current_cause_id.nil?
			render_error(:bad_request,"You cannot contribute until you have joined this cause")
			return false
		end

		return true

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
