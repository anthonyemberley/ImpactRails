class UpdateWeeklyBudgetService < Aldous::Service
	
	def initialize(params, user)
		@value = params[:value]
		@user = user
	end

	def perform
		update_user
		if @user
			Result::Success.new(result: @user)
		else
			Result::Failure.new(errors: @user.errors)
		end
	end

	private 

	def update_user
		@user.update_attribute(:weekly_budget, @value.to_f)
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
	end

end