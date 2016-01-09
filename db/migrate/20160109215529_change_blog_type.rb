class ChangeBlogType < ActiveRecord::Migration
  def change
  	change_column :blog_posts, :blog_body, :text
  	change_column :blog_comments, :message, :text
  	change_column :messages, :message_body, :text
  	change_column :organizations, :summary, :text
  end
end
