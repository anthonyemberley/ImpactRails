class Api::PlaidApiController < Api::ApiController
	PLAID_API_KEY = "plaid"

	def create_plaid_user
		response = CreatePlaidUserService.new(create_plaid_user_params).perform
		if response.success?
			plaid_user = response.result
			plaid_token = plaid_user.access_token
			if plaid_user.pending_mfa_questions.present?
				render status: :created , json: {
					:questions => plaid_user.pending_mfa_questions,
				}
			else
				if @current_user.plaid_token.present?
					DeletePlaidUserService.new(plaid_token).perform
				end
				@current_user.update_attribute(:plaid_token, plaid_token)
				@current_user.update_attribute(:transactions_updated_at, Time.now)
				render_default_user_response(@current_user)
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
				plaid_token = api_response.access_token
				@current_user.update_attribute(:plaid_token, plaid_token)
				@current_user.update_attribute(:transactions_updated_at, Time.now)
				if @current_user.plaid_token.present?
					DeletePlaidUserService.new(plaid_token).perform
				end
				render_default_user_response(@current_user)
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
				plaid_token = api_response[:access_token]
				@current_user.update_attribute(:plaid_token, plaid_token)
				render_default_user_response(@current_user)
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
				plaid_token = api_response[:access_token]
				@current_user.update_attribute(:plaid_token, plaid_token)
				render_default_user_response(@current_user)
			end
		else
			render_error(status, response.errors)
		end
	end

	def get_transactions
		# this service uses a standard http request because the plaid-rails gem does not support it
		plaid_access_token = @current_user.plaid_token
		gte_date = @current_user.transactions_updated_at
		response = GetTransactionsService.new(plaid_access_token, gte_date, @current_user).perform
		if response.success?
			transactions = response.result
			if transactions.size > 25
				transactions = transactions[0..25]
			end
			render status: :ok , json: transactions.as_json
		else
			puts "Unable to Get Transactions"
			render_error(status, response.errors)
		end
	end

	def get_banks
		response = GetBanksService.new.perform
		if response.success?
			render status: :ok , json: response.result
		else
			render_error(:internal_server_error, response.errors)
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

	''' Render '''
	def render_default_user_response(user)
    	user_response = user.as_json
    	user_response["needs_bank_information"] = user.plaid_token.blank?
    	user_response["needs_credit_card_information"] = user.stripe_customer_id.blank?
    	render status: :ok , json: user_response
	end
end
