class AddCauseToContribution < ActiveRecord::Migration
  def change
  	add_column :contributions, :cause_id, :integer
  	add_column :user_cause_relationships, :has_contributed, :boolean, :default => false
  	add_index :contributions, :cause_id
  end
end
