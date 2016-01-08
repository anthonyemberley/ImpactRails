class UseCauseService < Aldous::Service
	
	def initialize(user, amount)
		@user = user
		@amount = amount
		
	end

	def perform
		if @user.current_cause_id.nil?
			Result::Failure.new(errors: "User does not currently have a cause")
		end
		@cause = Cause.find_by(id:@user.current_cause_id)
		relationship = UserCauseRelationship.where(:user_id => @user.id).where(:cause_id => @cause.id).first
		puts "found relationship "+relationship.to_s
		relationship.increment!(:amount_contributed, @amount)
		puts "increment relationship amount "+ relationship.amount_contributed.to_s
		relationship.update_attribute(:last_contribution_date, Time.now)
		if !relationship.has_contributed
			puts "new contribution, create new relationship "
			@cause.increment!(:number_of_contributors,1)
			relationship.update_attribute(:has_contributed,true)
		end
		if contribution.save
			Result::Success.new(result: contribution)
		else
			puts "SAVE CONTRIBUTION ERRORS"
			Result::Failure.new(errors: contribution.errors)
		end
	end

end