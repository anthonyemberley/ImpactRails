class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :encrypted_password
      t.string :authentication_token
      t.string :salt

      t.timestamps null: false
    end
    add_index :users, :authentication_token
    add_index :users, :email
  end
end
