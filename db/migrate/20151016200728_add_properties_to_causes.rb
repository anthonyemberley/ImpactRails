class AddPropertiesToCauses < ActiveRecord::Migration
  def change
  	add_column :causes, :organization_logo_url, :string
  	add_column :causes, :organization_name, :string
  	rename_column :organizations, :photo_url, :logo_url
  end
end
