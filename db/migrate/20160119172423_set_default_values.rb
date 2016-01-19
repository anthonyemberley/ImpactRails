class SetDefaultValues < ActiveRecord::Migration
  def change
  	change_column_default :users, :pending_contribution_amount,0
  	change_column_default :users, :current_cause_amount_contributed, 0
  	change_column_default :users, :current_streak, 0
  end
end
