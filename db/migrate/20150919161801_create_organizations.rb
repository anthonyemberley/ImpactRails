class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :organization_name
      t.integer :nonprofit_id
      t.string :summary
      t.string :photo_url
      t.string :username
      t.string :encrypted_password
      t.string :contact_name
      t.string :contact_phone_number
      t.string :contact_email
      t.timestamps null: false
    end
  end
end
