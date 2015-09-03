class CreatePlaidUserService < Aldous::Service
	def initialize(plaid_params)
		@username = plaid_params[:username] 
		@password = plaid_params[:password]
		@bank_type = plaid_params[:bank_type]
		@pin = plaid_params[:pin]
	end

	def perform
		begin
			plaid_user = Plaid.add_user('connect', @username, @password, @bank_type, @pin, {list: true})
			Result::Success.new(result: plaid_user)
		rescue
			Result::Failure.new(errors: "Invalid Credentials. Your Account may be locked")
		end
	end

end