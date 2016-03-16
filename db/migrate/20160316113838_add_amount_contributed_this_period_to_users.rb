class AddAmountContributedThisPeriodToUsers < ActiveRecord::Migration
  def change
    add_column :users, :amount_contributed_this_period, :integer, default: 0
  end
end
