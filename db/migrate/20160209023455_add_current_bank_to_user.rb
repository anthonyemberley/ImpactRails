class AddCurrentBankToUser < ActiveRecord::Migration
  def change
  	add_column :users, :bank, :string
  end
end
