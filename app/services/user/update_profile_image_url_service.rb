class UpdateProfileImageURLService < Aldous::Service
	
	def initialize(params, user)
		@new_url = params[:user][:profile_image_url]
		@user = user
		puts "here2"
	end

	def perform
		puts "here3"
		update_user
		puts "here6"
		if @user
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end

	private 

	def update_user
		puts "here4"
		@user.update_attribute(:profile_image_url, @new_url.to_s)
		puts "here5"
	end

end