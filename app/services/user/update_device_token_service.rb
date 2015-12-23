class UpdateDeviceTokenService < Aldous::Service
	def initialize(user,device_token)
		@device_token = device_token
		@current_user = user
	end

	def perform
		if !@device_token.to_s.empty?
			if @current_user.update_attribute(:device_token,@device_token)
				Result::Success.new(result: @current_user)
			else
				Result::Failure.new(errors: @current_user.errors)
			end 
		end
	end
end