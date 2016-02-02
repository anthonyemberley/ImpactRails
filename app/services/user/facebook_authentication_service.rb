class FacebookAuthenticationService < Aldous::Service

	def initialize(facebook_params)
		@facebook_id = facebook_params[:facebook_id]
		@facebook_access_token = facebook_params[:facebook_access_token]
		@device_token = facebook_params[:device_token]
	end

	def perform
		facebook_user_object = fetch_facebook_user_object(@facebook_id, @facebook_access_token)
		if facebook_user_object.present?
			authenticate_facebook_user(facebook_user_object)
		else
			Result::Failure.new(errors:"Can't Authenticate Facebook User with this access token")	
		end
	end 

	private

		def fetch_facebook_user_object(facebook_id,facebook_access_token)
			begin
				return FbGraph2::User.new(facebook_id).authenticate(facebook_access_token).fetch
			rescue
				return nil
			end
		end
		# return user if facebook_id is found, create new user if not
		def authenticate_facebook_user(facebook_user_object)
			user = User.find_by facebook_id: facebook_user_object.id
			if user.present?
				UpdateDeviceTokenService.new(user,@device_token).perform
				Result::Success.new(result: user)
			else
				signup_facebook_user(facebook_user_object)
			end
		end

		def signup_facebook_user(facebook_user_object)
			new_user = User.new
			new_user.name = facebook_user_object.name
			new_user.facebook_id = facebook_user_object.id
			new_user.salt = BCrypt::Engine.generate_salt
			if new_user.save
				UpdateDeviceTokenService.new(new_user,@device_token).perform
				Result::Success.new(result: new_user)
			else
				Result::Failure.new(errors: new_user.errors)
			end
		end
end