class RenameUserProperties < ActiveRecord::Migration
  def change
  	rename_column :users, :encrypted_plaid_token, :plaid_token
  end
end
