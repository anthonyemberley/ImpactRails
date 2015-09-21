class FromUserOrCause < ActiveRecord::Migration
  def change
  	add_column :messages, :user_id, :integer
  	add_column :messages, :cause_id, :integer
  	add_column :messages, :from_user, :boolean
  	add_index :messages, :user_id
  	add_index :messages, :cause_id
  end
end
