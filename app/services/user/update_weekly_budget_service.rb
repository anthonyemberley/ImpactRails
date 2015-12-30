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
		last_date_string = @user.last_contribution_date.to_formatted_s(:db)
		now_date_string = Time.now.to_formatted_s(:db)
		puts "halfway through"
		puts "part of date string " + last_date_string[0,4]
		puts "date_string " + last_date_string
		puts "integer part of date string" + Integer(last_date_string[0,4]).to_s
		next_year = Integer(last_date_string[0,4]) < Integer(now_date_string[0,4])
		puts "year works"
		puts "month string " + @user.last_contribution_date.month.to_s  + "day string datetime" + Time.now.day.to_s
		next_month = Integer(last_date_string[5,6]) < Integer(now_date_string[5,6])
		puts "month works"
		puts "date " + last_date_string[6,7] + "date 2" + now_date_string[6,7]
		next_day = Integer(last_date_string[6,7]) < Integer(now_date_string[6,7])
		puts "finished next year stuff"
	end

end