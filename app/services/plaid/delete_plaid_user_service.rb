class DeletePlaidUserService < Aldous::Service
	def initialize(plaid_access_token)
		@plaid_access_token = plaid_access_token
	end

	def perform
		begin
			Plaid::Connection.delete('info', { access_token: @plaid_access_token })
			puts "Successfully deleted user"
			Result::Success.new(result: "Successfully Deleted Plaid User")
		rescue Exception => error
			puts "ERROR! "+error.to_s
			Result::Failure.new(errors: error)
		end
	end

end