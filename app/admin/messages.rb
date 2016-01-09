ActiveAdmin.register Message do
  config.sort_order = 'created_at_desc'
  config.per_page = 50
end