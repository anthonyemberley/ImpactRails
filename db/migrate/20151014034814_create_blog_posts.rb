class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.string :title
      t.string :blog_body
      t.string :image_url
      t.integer :cause_id

      t.timestamps null: false
    end
    add_index :blog_posts, :cause_id
  end
end
