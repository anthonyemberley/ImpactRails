class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :cause_id
      t.string :cause_name
      t.integer :user_id
      t.integer :amount
      t.boolean :transaction_completed

      t.timestamps null: false
    end
  end
end
