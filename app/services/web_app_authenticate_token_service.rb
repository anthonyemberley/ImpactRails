class WebAppAuthenticateTokenService < Aldous::Service

	def initialize(token)
	  @token = token
	end

	def perform
      organization = Organization.where(authentication_token: @token).first	#find user with that authenticadtion token
      if organization && Devise.secure_compare(organization.authentication_token, @token)
         Result::Success.new(result: organization)
      else
         Result::Failure.new
    	end
    end
end 