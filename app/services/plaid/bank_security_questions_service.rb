class BankSecurityQuestionsService < Aldous::Service
	def initialize(answer_params)
		@access_token = answer_params[:access_token]
		@answer = answer_params[:answer]
	end

	def perform
		begin
			plaid_user = Plaid.set_user(@access_token, ['connect'])
			api_response = plaid_user.mfa_authentication(@answer)
			Result::Success.new(result: api_response)
		rescue
			Result::Failure.new(errors: "Invalid MFA Answer")
		end
	end
end