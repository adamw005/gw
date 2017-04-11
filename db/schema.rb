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

ActiveRecord::Schema.define(version: 20170411172734) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accounts", force: :cascade do |t|
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "accounts", ["user_id"], name: "index_accounts_on_user_id", using: :btree

  create_table "balances", force: :cascade do |t|
    t.integer  "account_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal  "amount"
  end

  add_index "balances", ["account_id"], name: "index_balances_on_account_id", using: :btree

  create_table "bank_infos", force: :cascade do |t|
    t.string   "bank_num"
    t.string   "routing_num"
    t.integer  "account_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "bank_infos", ["account_id"], name: "index_bank_infos_on_account_id", using: :btree

  create_table "comments", force: :cascade do |t|
    t.text     "body"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "comments", ["project_id"], name: "index_comments_on_project_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "countries", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "code"
  end

  create_table "goals", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.decimal  "amount"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "goals", ["project_id"], name: "index_goals_on_project_id", using: :btree

  create_table "past_transactions", force: :cascade do |t|
    t.string   "type_of"
    t.decimal  "amount"
    t.integer  "project_id"
    t.string   "status"
    t.integer  "user_id"
    t.integer  "rewards_tier_id"
    t.integer  "release_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "past_transactions", ["project_id"], name: "index_past_transactions_on_project_id", using: :btree
  add_index "past_transactions", ["release_id"], name: "index_past_transactions_on_release_id", using: :btree
  add_index "past_transactions", ["rewards_tier_id"], name: "index_past_transactions_on_rewards_tier_id", using: :btree
  add_index "past_transactions", ["user_id"], name: "index_past_transactions_on_user_id", using: :btree

  create_table "posts", force: :cascade do |t|
    t.string   "title"
    t.text     "body"
    t.boolean  "release"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "posts", ["project_id"], name: "index_posts_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "title"
    t.string   "format"
    t.text     "body"
    t.text     "charge_occurrence"
    t.integer  "user_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "box_image_file_name"
    t.string   "box_image_content_type"
    t.integer  "box_image_file_size"
    t.datetime "box_image_updated_at"
  end

  add_index "projects", ["user_id"], name: "index_projects_on_user_id", using: :btree

  create_table "releases", force: :cascade do |t|
    t.integer  "project_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "released",   default: false
  end

  add_index "releases", ["project_id"], name: "index_releases_on_project_id", using: :btree

  create_table "rewards_tiers", force: :cascade do |t|
    t.integer  "level"
    t.string   "title"
    t.text     "body"
    t.decimal  "min_amount"
    t.integer  "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "rewards_tiers", ["project_id"], name: "index_rewards_tiers_on_project_id", using: :btree

  create_table "stripe_infos", force: :cascade do |t|
    t.integer  "account_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "customer_id"
    t.string   "stripe_id"
    t.string   "secret_key"
    t.string   "publishable_key"
  end

  add_index "stripe_infos", ["account_id"], name: "index_stripe_infos_on_account_id", using: :btree

  create_table "subscriptions", force: :cascade do |t|
    t.decimal  "amount"
    t.integer  "project_id"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "type"
    t.integer  "rewards_tier_id"
  end

  add_index "subscriptions", ["project_id"], name: "index_subscriptions_on_project_id", using: :btree
  add_index "subscriptions", ["rewards_tier_id"], name: "index_subscriptions_on_rewards_tier_id", using: :btree
  add_index "subscriptions", ["user_id"], name: "index_subscriptions_on_user_id", using: :btree

  create_table "transaction_queues", force: :cascade do |t|
    t.string   "type"
    t.decimal  "amount"
    t.integer  "project_id"
    t.integer  "user_id"
    t.integer  "rewards_tier_id"
    t.integer  "release_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "transaction_queues", ["project_id"], name: "index_transaction_queues_on_project_id", using: :btree
  add_index "transaction_queues", ["release_id"], name: "index_transaction_queues_on_release_id", using: :btree
  add_index "transaction_queues", ["rewards_tier_id"], name: "index_transaction_queues_on_rewards_tier_id", using: :btree
  add_index "transaction_queues", ["user_id"], name: "index_transaction_queues_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
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
    t.text     "stripe_customer_nbr"
    t.text     "paypal_customer_nbr"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "avatar"
    t.string   "full_name"
    t.string   "username"
    t.integer  "country_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
  end

  add_index "users", ["country_id"], name: "index_users_on_country_id", using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  add_foreign_key "accounts", "users"
  add_foreign_key "balances", "accounts"
  add_foreign_key "bank_infos", "accounts"
  add_foreign_key "comments", "projects"
  add_foreign_key "comments", "users"
  add_foreign_key "goals", "projects"
  add_foreign_key "past_transactions", "projects"
  add_foreign_key "past_transactions", "releases"
  add_foreign_key "past_transactions", "rewards_tiers"
  add_foreign_key "past_transactions", "users"
  add_foreign_key "posts", "projects"
  add_foreign_key "projects", "users"
  add_foreign_key "releases", "projects"
  add_foreign_key "rewards_tiers", "projects"
  add_foreign_key "stripe_infos", "accounts"
  add_foreign_key "subscriptions", "projects"
  add_foreign_key "subscriptions", "rewards_tiers"
  add_foreign_key "subscriptions", "users"
  add_foreign_key "transaction_queues", "projects"
  add_foreign_key "transaction_queues", "releases"
  add_foreign_key "transaction_queues", "rewards_tiers"
  add_foreign_key "transaction_queues", "users"
  add_foreign_key "users", "countries"
end
