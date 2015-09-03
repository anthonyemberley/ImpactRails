class Api::PlaidApiController < Api::ApiController
	PLAID_API_KEY = "plaid"
	NEEDS_MFA_INDICATOR = "Requires further authentication"

	def create_plaid_user
		response = CreatePlaidUserService.new(create_plaid_user_params).perform
		if response.success?
			plaid_user = response.result
			plaid_access_token = plaid_user.access_token
			encrypted_plaid_token = encrypt(plaid_access_token)
			if plaid_user.api_res == NEEDS_MFA_INDICATOR
				render status: :created , json: {
					:questions => plaid_user.pending_mfa_questions.as_json(:except => [:access_token]),
					:encrypted_plaid_token => encrypted_plaid_token
				}
			else
				@current_user.update_attribute(:encrypted_plaid_token, encrypted_plaid_token)
				ApiController.render_success_with_message(:ok,message)
			end
		else
			render_error(status, response.errors)
		end
	end

	def answer_security_question
		response = BankSecurityQuestionsService.new(question_answer_params).perform
		if response.success?
			api_response = response.result
			plaid_access_token = api_response.access_token
			encrypted_plaid_token = encrypt(plaid_access_token)
			status = api_response.api_res == NEEDS_MFA_INDICATOR ? :created : :ok
			if status == :ok
				@current_user.update_attribute(:encrypted_plaid_token, encrypted_plaid_token)
				render_success_with_message(:ok,"Successfully hooked up bank account")
			else
				render status: status , json: api_response.as_json
			end	
		else
			render_error(status, response.errors)
		end
	end

	def update_plaid_user
		response = UpdatePlaidUserService.new(update_plaid_user_params).perform
		if response.success?
			plaid_user = response.result
			render status: :ok , json: plaid_user.as_json
		else
			render_error(status, response.errors)
		end
	end

	def get_transactions
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
						:access_token => decrypt(params[:plaid][:encrypted_plaid_token]),
						:pin => params[:plaid][:pin]
		}
		return new_params
	end

	def question_answer_params
		new_params = {:answer=> params[:plaid][:answer],
						:access_token => decrypt(params[:plaid][:encrypted_plaid_token])
		}
		return new_params
	end
end
