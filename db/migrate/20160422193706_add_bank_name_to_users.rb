class AddBankNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :bank_name, :string
  end
end
