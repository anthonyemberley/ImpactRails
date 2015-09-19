class UpdateOrganizationModel < ActiveRecord::Migration
  def change
  	add_column :organizations, :salt, :string
  	add_column :organizations, :authentication_token, :string
  	add_column :causes, :organization_id, :integer
  	add_index :causes, :organization_id
  end
end
