class AddEncryptedPlaidToken < ActiveRecord::Migration
  def change
  	add_column :users, :encrypted_plaid_token, :string
  end
end
