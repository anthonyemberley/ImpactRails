class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
      t.integer :cause_id
      t.integer :user_id
      t.string :cause_name

      t.timestamps null: false
    end
    add_index :conversations, :cause_id
    add_index :conversations, :user_id
  end
end
