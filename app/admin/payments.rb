ActiveAdmin.register Payment do
  config.sort_order = 'created_at_desc'
  config.per_page = 25

  index do
  	selectable_column
  	column :id
    column :amount
    column :cause_name
    column :transaction_completed
    column "Cause ID",:cause_id
    column "Cause Name",:cause_name
    column :created_at
    column "User ID", :user_id
    column "Stripe Transaction ID", :stripe_transaction_id
    actions
  end
end