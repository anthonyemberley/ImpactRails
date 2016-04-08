class AddTransactionsUpdatedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :transactions_updated_at, :datetime
  end
end
