class AddAddresses < ActiveRecord::Migration
  def change
  	add_column :causes, :city, :string
  	add_column :causes, :state, :string
  	add_column :causes, :country, :string
  	add_column :causes, :longitude, :decimal, {:precision=>10, :scale=>6}
  	add_column :causes, :latitude, :decimal, {:precision=>10, :scale=>6}
  	add_column :organizations, :address, :string
  	add_column :organizations, :city, :string
  	add_column :organizations, :state, :string
  	add_column :organizations, :country, :string
  	add_column :organizations, :zipcode, :integer
  end
end
