class CreateCategories < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :name
      t.string :icon_url
      t.string :selected_icon_url

      t.timestamps null: false
    end
  end
end
