class CreateBlogComments < ActiveRecord::Migration
  def change
    create_table :blog_comments do |t|
      t.integer :cause_id
      t.integer :user_id
      t.string :message

      t.timestamps null: false
    end
    add_index :blog_comments, :cause_id
    add_index :blog_comments, :user_id
  end
end
