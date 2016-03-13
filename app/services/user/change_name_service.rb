class ChangeNameService < Aldous::Service
	
	def initialize(user,new_name)
		@user = user
		@new_name = new_name
	end

	def perform
		if @user.update_attribute(:name,@new_name)
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end
end