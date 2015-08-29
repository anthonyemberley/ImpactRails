class AuthenticateTokenService < Aldous::Service

	def initialize(token)
		@token = token
	end

	def perform
		user = User.where(authentication_token: @token).first	#find user with that authenticadtion token
		if user && Devise.secure_compare(user.authentication_token, @token)
      		Result::Success.new(result: user)
    	else
      		Result::Failure.new
    	end
    end
end 