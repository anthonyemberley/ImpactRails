class UpdateUserCauseService < Aldous::Service
	def initialize(user,amount)
		@amount = amount
		@user = user
		@cause = Cause.find_by(id:@user.current_cause_id)
	end

	def perform
		relationship = UserCauseRelationship.where(:user_id => @user.id).where(:cause_id => @cause.id).first
		puts "found relationship "+relationship.to_s
		relationship.increment!(:amount_contributed, @amount)
		puts "increment relationship amount "+ relationship.amount_contributed.to_s
		relationship.update_attribute(:last_contribution_date, Time.now)
		if !relationship.has_contributed
			puts "new contribution, update flag of whether or not user has contributed"
			@cause.increment!(:number_of_contributors,1)
			relationship.update_attribute(:has_contributed,true)
		end
		@cause.increment!(:current_total, @amount)
		Result::Success.new(result: relationship)
	end

end