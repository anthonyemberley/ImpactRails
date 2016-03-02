class AddAutomaticDonationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :automatic_donations, :boolean, default: false
  end
end
