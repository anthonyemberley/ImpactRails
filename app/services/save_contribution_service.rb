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
		puts "contributing: "+@amount.to_s
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
		puts "about to update user"
		time_since = Time.now - @user.last_contribution_date 
		puts "time_since " + time_since.to_s
		last_date = @user.last_contribution_date
		now = Time.now
		last_date_string = @user.last_contribution_date.to_formatted_s(:db)
		puts "before year"
		next_year = last_date.year < now.year
		puts "year works"
		next_month = last_date.month < now.month
		puts "month works"
		next_day = last_date.day < now.day
		puts "finished next year stuff"
		puts "next year " + next_year.to_s + "next month " + next_month.to_s + "next_day " + next_day.to_s
		#NEED TO TEST THE DATES MORE
		if time_since < 86400 && (next_day || next_month || next_year) && @user.last_contribution_date != nil
			puts "incrementing streak"
			@user.increment!(:current_streak,1)
		elsif time_since >= 86400 || @user.last_contribution_date == nil
			puts "setting streak to 1"
			@user.update_attribute(:current_streak,1)
		end

		@user.update_attribute(:last_contribution_date, Time.now)
		puts "incrementing amount: "+@amount.to_s+" by 1"
		@user.increment!(:current_cause_amount_contributed, @amount)

		puts "successfully incremented amount"
	end

	def update_user_cause_relationship
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
	end

end