# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160316115003) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "blog_comments", force: :cascade do |t|
    t.integer  "cause_id"
    t.integer  "user_id"
    t.text     "message"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "blog_post_id"
  end

  add_index "blog_comments", ["blog_post_id"], name: "index_blog_comments_on_blog_post_id", using: :btree
  add_index "blog_comments", ["cause_id"], name: "index_blog_comments_on_cause_id", using: :btree
  add_index "blog_comments", ["user_id"], name: "index_blog_comments_on_user_id", using: :btree

  create_table "blog_posts", force: :cascade do |t|
    t.string   "title"
    t.text     "blog_body"
    t.string   "image_url"
    t.integer  "cause_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "blog_posts", ["cause_id"], name: "index_blog_posts_on_cause_id", using: :btree

  create_table "categories", force: :cascade do |t|
    t.string   "name"
    t.string   "icon_url"
    t.string   "selected_icon_url"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "causes", force: :cascade do |t|
    t.string   "name"
    t.string   "category"
    t.string   "description"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.integer  "number_of_contributors"
    t.integer  "goal"
    t.integer  "current_total"
    t.string   "profile_image_url"
    t.datetime "end_date"
    t.integer  "organization_id"
    t.string   "organization_logo_url"
    t.string   "organization_name"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.decimal  "longitude",              precision: 10, scale: 6
    t.decimal  "latitude",               precision: 10, scale: 6
  end

  add_index "causes", ["organization_id"], name: "index_causes_on_organization_id", using: :btree

  create_table "contributions", force: :cascade do |t|
    t.decimal  "amount"
    t.integer  "user_id"
    t.string   "user_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "cause_id"
    t.integer  "payment_id"
    t.string   "cause_name"
  end

  add_index "contributions", ["cause_id"], name: "index_contributions_on_cause_id", using: :btree
  add_index "contributions", ["payment_id"], name: "index_contributions_on_payment_id", using: :btree
  add_index "contributions", ["user_id"], name: "index_contributions_on_user_id", using: :btree

  create_table "conversations", force: :cascade do |t|
    t.integer  "cause_id"
    t.integer  "user_id"
    t.string   "cause_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "conversations", ["cause_id"], name: "index_conversations_on_cause_id", using: :btree
  add_index "conversations", ["user_id"], name: "index_conversations_on_user_id", using: :btree

  create_table "messages", force: :cascade do |t|
    t.string   "title"
    t.text     "message_body"
    t.string   "image_url"
    t.integer  "conversation_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "user_id"
    t.integer  "cause_id"
    t.boolean  "from_user"
  end

  add_index "messages", ["cause_id"], name: "index_messages_on_cause_id", using: :btree
  add_index "messages", ["conversation_id"], name: "index_messages_on_conversation_id", using: :btree
  add_index "messages", ["user_id"], name: "index_messages_on_user_id", using: :btree

  create_table "organizations", force: :cascade do |t|
    t.string   "organization_name"
    t.integer  "nonprofit_id"
    t.text     "summary"
    t.string   "logo_url"
    t.string   "username"
    t.string   "encrypted_password"
    t.string   "contact_name"
    t.string   "contact_phone_number"
    t.string   "contact_email"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.string   "salt"
    t.string   "authentication_token"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.integer  "zipcode"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "amount"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.boolean  "has_charged", default: false
    t.string   "user_name"
    t.string   "user_email"
  end

  add_index "payments", ["user_id"], name: "index_payments_on_user_id", using: :btree

  create_table "stripe_charges", force: :cascade do |t|
    t.integer  "amount"
    t.integer  "user_id"
    t.string   "stripe_id"
    t.string   "stripe_transaction_id"
    t.string   "user_name"
    t.integer  "payment_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  create_table "user_categories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "category_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "user_cause_relationships", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "cause_id"
    t.datetime "created_at",                             null: false
    t.datetime "updated_at",                             null: false
    t.integer  "amount_contributed"
    t.date     "last_contribution_date"
    t.boolean  "has_contributed",        default: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "encrypted_password"
    t.string   "authentication_token"
    t.string   "salt"
    t.datetime "created_at",                                                 null: false
    t.datetime "updated_at",                                                 null: false
    t.integer  "facebook_id",                      limit: 8
    t.integer  "current_cause_id"
    t.string   "current_cause_name"
    t.datetime "current_cause_join_date"
    t.string   "plaid_token"
    t.integer  "total_amount_contributed"
    t.integer  "current_cause_amount_contributed",           default: 0
    t.datetime "last_contribution_date"
    t.integer  "pending_contribution_amount",                default: 0
    t.string   "stripe_customer_id"
    t.integer  "current_payment_id"
    t.integer  "weekly_budget"
    t.integer  "current_streak",                             default: 0
    t.integer  "total_contributions"
    t.string   "device_token"
    t.string   "bank"
    t.boolean  "automatic_donations",                        default: false
    t.string   "profile_image_url"
    t.integer  "amount_contributed_this_period",             default: 0
    t.datetime "budget_period_start_time"
  end

  add_index "users", ["authentication_token"], name: "index_users_on_authentication_token", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", using: :btree
  add_index "users", ["facebook_id"], name: "index_users_on_facebook_id", using: :btree

end
