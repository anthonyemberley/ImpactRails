class AddPropertiesToPayments < ActiveRecord::Migration
  def change
  	add_column :payments, :user_name, :string
  	add_column :payments, :user_email, :string
  end
end
