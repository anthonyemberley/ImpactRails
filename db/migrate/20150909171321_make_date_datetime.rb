class MakeDateDatetime < ActiveRecord::Migration
  def change
  	change_column :users, :last_contribution_date , :datetime
  end
end
