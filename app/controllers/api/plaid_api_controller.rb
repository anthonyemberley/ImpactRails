class Api::PlaidApiController < Api::ApiController
	PLAID_API_KEY = "plaid"

	def create_plaid_user
		response = CreatePlaidUserService.new(create_plaid_user_params).perform
		if response.success?
			plaid_user = response.result
			plaid_access_token = plaid_user.access_token
			encrypted_plaid_token = encrypt(plaid_access_token)
			if plaid_user.api_res == NEEDS_MFA_INDICATOR
				render status: :created , json: {
					:questions => plaid_user.pending_mfa_questions,
				}
			else
				@current_user.update_attribute(:encrypted_plaid_token, encrypted_plaid_token)
				render_success_with_message(:ok,"Successfully hooked up bank account")
			end
		else
			render_error(:unauthorized, response.errors)
		end
	end

	def answer_security_question
		response = BankSecurityQuestionsService.new(question_answer_params).perform
		if response.success?
			api_response = response.result
			status = api_response.pending_mfa_questions.present? ? :created : :ok
			if status == :ok
				encrypted_plaid_token = encrypt(api_response.access_token)
				@current_user.update_attribute(:encrypted_plaid_token, encrypted_plaid_token)
				render_success_with_message(:ok,"Successfully hooked up bank account")
			else
				render status: status , json: api_response.pending_mfa_questions.as_json
			end	
		else
			render_error(status, response.errors)
		end
	end

	def retrieve_plaid_user
		# this service uses a standard http request because the plaid-rails gem does not support it
		response = RetrievePlaidUserService.new(update_plaid_user_params).perform
		if response.success?
			api_response = response.result
			if api_response.has_key?("mfa")
				render status: :created , json: api_response.as_json
			else
				plaid_access_token = api_response[:access_token]
				encrypted_plaid_token = encrypt(plaid_access_token)
				@current_user.update_attribute(:encrypted_plaid_token, encrypted_plaid_token)
				render_success_with_message(:ok,"Successfully retrieved bank account")
			end
		else
			render_error(status, response.errors)
		end
	end

	def retrieve_user_questions
		# this service uses a standard http request because the plaid-rails gem does not support it
		response = RetrieveUserSecurityQuestionsService.new(question_answer_params).perform
		if response.success?
			api_response = response.result
			if api_response.has_key?("mfa")
				render status: :created , json: api_response.as_json
			else
				plaid_access_token = api_response[:access_token]
				encrypted_plaid_token = encrypt(plaid_access_token)
				@current_user.update_attribute(:encrypted_plaid_token, encrypted_plaid_token)
				render_success_with_message(:ok,"Successfully retrieved bank account")
			end
		else
			render_error(status, response.errors)
		end
	end

	def get_transactions
		# this service uses a standard http request because the plaid-rails gem does not support it
		plaid_access_token = decrypt(@current_user.encrypted_plaid_token)
		response = GetTransactionsService.new(plaid_access_token).perform
		if response.success?
			transactions = response.result
			render status: :ok , json: transactions.as_json
		else
			render_error(status, response.errors)
		end
	end

	private

		'''PARAMS '''
	def create_plaid_user_params 
	    params.require(PLAID_API_KEY).permit(:username,:password,:bank_type, :pin)
	end

	def update_plaid_user_params
		new_params = {:username => params[:plaid][:username],
						:password=> params[:plaid][:password],
						:access_token => params[:plaid][:plaid_access_token],
						:pin => params[:plaid][:pin]
		}
		return new_params
	end

	def question_answer_params
		new_params = {:answer=> params[:plaid][:answer],
						:access_token => params[:plaid][:plaid_access_token]
		}
		return new_params
	end
end
