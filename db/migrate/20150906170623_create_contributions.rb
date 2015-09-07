class CreateContributions < ActiveRecord::Migration
  def change
    create_table :contributions do |t|
      t.decimal :amount
      t.integer :user_id
      t.string :user_name
      t.string :stripe_transaction_id

      t.timestamps null: false
    end
    add_index :contributions, :user_id
  end
end
