class AddContributionAttributesToUser < ActiveRecord::Migration
  def change
  	add_column :users, :total_amount_contributed, :integer
  	add_column :users, :current_cause_amount_contributed, :integer
  	add_column :user_cause_relationships, :amount_contributed, :integer
  	add_column :users, :last_contribution_date, :date
  	add_column :user_cause_relationships, :last_contribution_date, :date
  	add_column :users, :amount_saved_today, :integer
  	change_column :causes, :goal, :integer
  	change_column :causes, :current_total, :integer
  end
end
