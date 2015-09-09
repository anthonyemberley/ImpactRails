class AddPaymentAttributes < ActiveRecord::Migration
  def change
  	add_column :users, :current_payment_id, :integer
  	add_index :payments, :cause_id
  	add_index :payments, :user_id
  	change_column :payments, :transaction_completed, :boolean, default: false
  	rename_column :users, :amount_saved_today, :pending_contribution_amount
  	add_column :contributions, :payment_id, :integer
  	add_index :contributions, :payment_id
  end
end
