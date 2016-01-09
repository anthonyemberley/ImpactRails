ActiveAdmin.register Payment do
  config.sort_order = 'created_at_desc'
  config.per_page = 25

  index do
  	selectable_column
  	column :id
    column "User ID", :user_id
    column :amount
    column :transaction_completed
    column "Stripe Transaction ID", :stripe_transaction_id
    column :created_at
    column :updated_at
    actions
  end
end