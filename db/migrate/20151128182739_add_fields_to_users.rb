class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :weekly_budget, :decimal
    add_column :users, :current_streak, :integer
    add_column :users, :total_contributions, :integer
  end
end
