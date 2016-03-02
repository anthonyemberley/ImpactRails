class UpdateAutomaticDonationsService < Aldous::Service
	
	def initialize(user)
		@user = user
		@new_value = !user.automatic_donations
	end

	def perform
		if @user.update_attribute(:automatic_donations,@new_value)
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end
end