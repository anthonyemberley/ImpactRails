ActiveAdmin.register BlogPost do
  permit_params :cause_id, :title, :blog_body, :image_url ## Add this line
  config.sort_order = 'created_at_desc'
  config.per_page = 50
end