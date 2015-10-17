class AddBlogPostIdToBlogComment < ActiveRecord::Migration
  def change
    add_column :blog_comments, :blog_post_id, :integer
    add_index :blog_comments, :blog_post_id
  end
end
