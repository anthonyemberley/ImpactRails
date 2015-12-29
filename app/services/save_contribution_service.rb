class SaveContributionService < Aldous::Service
	
	def initialize(amount, user)
		@amount = amount
		@user = user
		@cause = Cause.find_by(id:@user.current_cause_id)
	end

	def perform
		puts "SAVE CONTRIBUTION SERVICE!!!"
		contribution = Contribution.new
		contribution.amount = @amount
		contribution.user_id = @user.id
		contribution.user_name = @user.name
		contribution.cause_id = @cause.id
		if contribution.save
			update_all
			Result::Success.new(result: contribution)
		else
			puts "SAVE CONTRIBUTION ERRORS"
			Result::Failure.new(errors: contribution.errors)
		end
	end

	private 

	#TODO: Figure out what happens if one of these updates fail and how to handle it

	def update_all
		update_user
		update_user_cause_relationship
	end

	def update_user
		@user.increment!(:total_amount_contributed, @amount)

		#checking if streak should be updated
		time_since = @user.last_contribution_date.since()
		last_date_string = @user.last_contribution_date.to_formatted_s(:db)
		now_date_string = Time.now.to_formatted_s(:db)
		next_year = Integer(last_date_string[0,4]) <= Integer(now_date_string[0,4])
		next_month = Integer(last_date_string[5,7]) <= Integer(now_date_string[5,7])
		next_day = Integer(last_date_string[8,10]) <= Integer(now_date_string[8,10])
		if time_since < 86400 && (next_day || next_month || next_year)
			@user.increment!(:current_streak,1)
		elsif time_since >= 86400
			@user.update_attribute(:current_streak,1)
		end

		@user.update_attribute(:last_contribution_date, Time.now)
		@user.increment!(:current_cause_amount_contributed, @amount)
	end

	def update_user_cause_relationship
		relationship = UserCauseRelationship.where(:user_id => @user.id).where(:cause_id => @cause.id).first
		relationship.increment!(:amount_contributed, @amount)
		relationship.update_attribute(:last_contribution_date, Time.now)
		if !relationship.has_contributed
			@cause.increment!(:number_of_contributors,1)
			relationship.update_attribute(:has_contributed,true)
		end
	end

end