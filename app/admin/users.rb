ActiveAdmin.register User do
  config.sort_order = 'name_asc'
  config.per_page = 25
  index do
  	selectable_column
  	column :id
  	column :name
  	column :email
  	column :facebook_id
  	column :current_cause_id
  	column :current_cause_name
  	column :current_cause_join_date
  	column :total_amount_contributed
  	column :current_cause_amount_contributed
  	column :last_contribution_date
    column :pending_contribution_amount
  	column :current_payment_id
  	column :weekly_budget
  	column :current_streak
  	column :total_contributions
  	column :created_at
  	column :updated_at
  	column :salt
  	column :encrypted_password
  	column :authentication_token
  	column :device_token
  	column :plaid_token
  	column :stripe_customer_id
  	actions 
  end
end