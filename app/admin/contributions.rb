ActiveAdmin.register Contribution do
  config.sort_order = 'created_at_desc'
  config.per_page = 50
  index do
  	selectable_column
  	column :id
    column :amount
    column :user_name
    column "User ID",:user_id
    column "Cause ID",:cause_id
    column "Payment ID",:payment_id
    actions
  end
end