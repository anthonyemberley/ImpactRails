class LeaveCauseService < Aldous::Service
	def initialize(user)
		@user = user
	end

	def perform
		cause = Cause.find_by(id: @user.current_cause_id)
		update_user_current_cause_info(@user)
		Result::Success.new(result: cause)
	end

	private
		def update_user_current_cause_info(user)
			user.update_attribute(:current_cause_id, nil)
			user.update_attribute(:current_cause_name, nil)
			user.update_attribute(:current_cause_join_date, nil)
		end
end