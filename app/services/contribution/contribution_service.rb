class ContributionService < Aldous::Service
	
	def initialize(amount, user)
		@amount = amount
		@user = user
		@cause = Cause.find_by(id:@user.current_cause_id)
	end

	def perform
		puts "SAVE CONTRIBUTION SERVICE!!!"
		if @user.current_payment_id.nil?
			puts "@user.current_payment_id is nil"
			Result::Failure.new(errors: "User does not have a current payment")
		end
		contribution = Contribution.new (
							:amount => @amount,
							:user_id => @user.id,
							:user_name => @user.name,
							:cause_id => @cause.id,
							:cause_name => @cause.name,
							:payment_id => @user.current_payment_id
						)
		puts "contributing: "+@amount.to_s
		if contribution.save
			update_contribution_amount
			update_contribution_streak
			puts "successfully incremented amount"
			Result::Success.new(result: contribution)
		else
			puts "SAVE CONTRIBUTION ERRORS"
			Result::Failure.new(errors: contribution.errors)
		end
	end

	def update_contribution_amount
		@user.increment!(:total_amount_contributed, contribution.amount)
		puts "incrementing amount: "+contribution.amount.to_s+" by 1"
		@user.increment!(:current_cause_amount_contributed, @amount)
	end

	def update_contribution_streak
		#checking if streak should be updated
		time_since = Time.now - @user.last_contribution_date 
		last_date = @user.last_contribution_date
		now = Time.now
		next_year = last_date.year < now.year
		next_month = last_date.month < now.month
		next_day = last_date.day < now.day
		#NEED TO TEST THE DATES MORE
		if time_since < 86400 && (next_day || next_month || next_year) && @user.last_contribution_date != nil
			@user.increment!(:current_streak,1)
		elsif time_since >= 86400 || @user.last_contribution_date == nil
			@user.update_attribute(:current_streak,1)
		end
		@user.update_attribute(:last_contribution_date, Time.now)
	end

end