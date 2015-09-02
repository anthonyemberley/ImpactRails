class CreateUserCauseRelationships < ActiveRecord::Migration
  def change
    create_table :user_cause_relationships do |t|
      t.integer :user_id
      t.integer :cause_id

      t.timestamps null: false
    end
  end
end
