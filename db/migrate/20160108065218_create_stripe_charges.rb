class CreateStripeCharges < ActiveRecord::Migration
  def change
    create_table :stripe_charges do |t|
      t.integer :amount
      t.integer :user_id
      t.string :stripe_id
      t.string :stripe_transaction_id
      t.string :user_name
      t.integer :payment_id

      t.timestamps null: false
    end
  end
end
