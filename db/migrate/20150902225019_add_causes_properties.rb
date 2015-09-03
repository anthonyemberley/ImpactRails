class AddCausesProperties < ActiveRecord::Migration
  def change
  	add_column :causes, :number_of_contributors, :integer
  	add_column :causes, :goal, :decimal, :precision => 8, :scale => 2
  	add_column :causes, :current_total, :decimal, :precision => 8, :scale => 2
  	add_column :causes, :profile_image_url, :string
  	add_column :causes, :end_date, :datetime
  end
end
