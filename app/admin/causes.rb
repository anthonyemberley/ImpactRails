ActiveAdmin.register Cause do
  permit_params :name, :category, :description, :number_of_contributors, :goal, :current_total, \
                :profile_image_url, :end_date, :organization_id, :organization_logo_url, :organization_name, \
                :city, :state, :country, :longitude, :latitude
  config.sort_order = 'name_asc'
  config.per_page = 25
  form do |f|
    f.inputs "Create Cause" do
      f.input :name
      f.input :category
      f.input :description
      f.input :number_of_contributors
      f.input :goal
      f.input :current_total
      f.input :profile_image_url
      f.input :end_date
      f.input :organization_id
      f.input :organization_logo_url
      f.input :organization_name
      f.input :city
      f.input :state
      f.input :country, :as => :string
      f.input :longitude
      f.input :latitude
    end
    f.actions
  end
end

    # t.string   "name"
    # t.string   "category"
    # t.string   "description"
    # t.datetime "created_at",                                      null: false
    # t.datetime "updated_at",                                      null: false
    # t.integer  "number_of_contributors"
    # t.integer  "goal"
    # t.integer  "current_total"
    # t.string   "profile_image_url"
    # t.datetime "end_date"
    # t.integer  "organization_id"
    # t.string   "organization_logo_url"
    # t.string   "organization_name"
    # t.string   "city"
    # t.string   "state"
    # t.string   "country"
    # t.decimal  "longitude",              precision: 10, scale: 6
    # t.decimal  "latitude",               precision: 10, scale: 6