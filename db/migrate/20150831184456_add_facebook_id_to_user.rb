class AddFacebookIdToUser < ActiveRecord::Migration
  def change
  	add_column :users, :facebook_id, :integer, :limit => 8
  	add_index :users, :facebook_id
  end
end
