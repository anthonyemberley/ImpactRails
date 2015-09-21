class MoveStripeTransactionId < ActiveRecord::Migration
  def change
  	remove_column :contributions, :stripe_transaction_id
  	add_column :payments, :stripe_transaction_id, :string
  end
end
