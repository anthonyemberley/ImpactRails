class OrganizationLoginService < Aldous::Service

	def initialize(login_params)
		@username = login_params[:username]
		@inputted_password = login_params[:password]
	end

	def perform
		organization = Organization.find_by(username: @username)
		if organization && BCrypt::Engine.hash_secret(@inputted_password, organization.salt) == organization.encrypted_password
	   		Result::Success.new(result: organization)
		else 
	   		Result::Failure.new(errors: "Invalid Username and Password")
		end
	end

end