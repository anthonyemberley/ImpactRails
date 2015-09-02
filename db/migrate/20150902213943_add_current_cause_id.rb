class AddCurrentCauseId < ActiveRecord::Migration
  def change
  	add_column :users, :current_cause_id, :integer
  	add_column :users, :current_cause_name, :string
  	add_column :users, :current_cause_join_date, :datetime
  end
end
