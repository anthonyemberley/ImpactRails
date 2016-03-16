class FlatDonationService < Aldous::Service
	
	def initialize(amount, user, cause_id)
		@amount = amount
		@user = user
		@cause = Cause.find_by(id:cause_id)
	end

	def perform
		puts "SAVE FLAT DONATION SERVICE!!!"
		if @user.current_payment_id.nil?
			puts "@user.current_payment_id is nil"
			Result::Failure.new(errors: "User does not have a current payment")
		end

		#check for weekly budget overages
		last_budget_start_period = @user.budget_period_start_time.nil? ? Time.now : @user.budget_period_start_time
		more_than_a_week = last_budget_start_period + 7.days < Time.now
		if more_than_a_week && !@user.weekly_budget.nil?
			if @amount > @user.weekly_budget 
				Result::Failure.new(errors: "Above the weekly budget")
			end

		elsif !more_than_a_week && !@user.weekly_budget.nil?
			if @amount + @user.amount_contributed_this_period > @user.weekly_budget
				Result::Failure.new(errors: "Above the weekly budget")
			end
		end

		contribution = Contribution.create(
							amount: @amount,
							user_id: @user.id,
							user_name: @user.name,
							cause_id: @cause.id,
							cause_name: @cause.name,
							payment_id: @user.current_payment_id
						)
		puts "Donating: "+@amount.to_s
		if contribution.save
			update_contribution_amount(contribution)
			update_weekly_budget
			update_contribution_streak
			puts "successfully incremented amount"
			Result::Success.new(result: contribution)
		else
			puts "SAVE CONTRIBUTION ERRORS"
			puts contribution.errors.to_s
			Result::Failure.new(errors: contribution.errors)
		end
	end

	def update_contribution_amount(contribution)
		@user.increment!(:total_amount_contributed, contribution.amount)
		puts "incrementing amount: "+contribution.amount.to_s+" by 1"
		if @cause.id == @user.current_cause_id
			@user.increment!(:current_cause_amount_contributed, contribution.amount)
		end
	end


	def update_weekly_budget
		if @user.budget_period_start_time.nil?
			@user.update_attribute(:budget_period_start_time,Time.now)
		end
		last_budget_start_period = @user.budget_period_start_time
		more_than_a_week = last_budget_start_period + 7.days < Time.now
		if more_than_a_week
			@user.update_attribute(:budget_period_start_time,Time.now)
			@user.update_attribute(:amount_contributed_this_period,@amount)
		else
			@user.increment!(:amount_contributed_this_period,@amount)
		end
	end

	def update_contribution_streak
		#checking if streak should be updated
		last_contribution_date = @user.last_contribution_date.nil? ? Time.now : @user.last_contribution_date 
		time_since = Time.now - last_contribution_date
		last_date = last_contribution_date
		now = Time.now
		next_year = last_date.year < now.year
		next_month = last_date.month < now.month
		next_day = last_date.day < now.day
		#NEED TO TEST THE DATES MORE
		if time_since < 86400 && (next_day || next_month || next_year) && last_contribution_date != nil
			@user.increment!(:current_streak,1)
		elsif time_since >= 86400 || last_contribution_date == nil
			@user.update_attribute(:current_streak,1)
		end
		@user.update_attribute(:last_contribution_date, Time.now)
	end

end