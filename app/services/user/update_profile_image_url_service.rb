class UpdateProfileImageURLService < Aldous::Service
	
	def initialize(params, user)
		@new_url = params[:url]
		@user = user
	end

	def perform
		update_user
		if @user
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end

	private 

	def update_user
		@user.update_attribute(:profile_image_url, @value.to_s)
	end

end