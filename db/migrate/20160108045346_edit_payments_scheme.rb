class EditPaymentsScheme < ActiveRecord::Migration
  def change
  	add_column :payments, :has_charged, :boolean, :default => false
  	remove_column :payments, :stripe_transaction_id
  	remove_column :payments, :transaction_completed
  	remove_column :payments, :cause_id
  	remove_column :payments, :cause_name
  	add_column :contributions, :cause_name, :string
  	#each contribution can determine if it's been charged by getting contribution.payment.has_charged
  	#when payments passes threshold go through and set to true
  end
end
