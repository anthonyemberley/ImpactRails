class ChangeDecimalFormatInUsers < ActiveRecord::Migration
  def change
  	change_column(:users, :weekly_budget, :integer)
  end
end
