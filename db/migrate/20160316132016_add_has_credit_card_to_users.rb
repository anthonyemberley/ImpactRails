class AddHasCreditCardToUsers < ActiveRecord::Migration
  def change
    add_column :users, :has_credit_card, :boolean, default: false
  end
end
