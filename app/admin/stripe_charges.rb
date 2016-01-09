ActiveAdmin.register StripeCharge do
  config.sort_order = 'created_at_desc'
  config.per_page = 50
  index do
  	selectable_column
  	column :amount
    column :user_id
    column :stripe_id
    column :stripe_transaction_id
    column :user_name
    column "Payment ID",:payment_id
    column :created_at
    column :updated_at
    actions
  end
end