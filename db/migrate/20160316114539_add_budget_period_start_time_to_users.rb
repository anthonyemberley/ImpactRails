class AddBudgetPeriodStartTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :budget_period_start_time, :datetime
  end
end
