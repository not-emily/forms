# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_02_150912) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_invites", force: :cascade do |t|
    t.integer "account_id"
    t.integer "user_id"
    t.string "email"
    t.string "role"
    t.string "status"
    t.string "apikey"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "account_users", force: :cascade do |t|
    t.integer "account_id"
    t.integer "user_id"
    t.string "status"
    t.string "role"
    t.boolean "owner"
    t.string "apikey"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "account_id"], name: "index_account_users_on_user_id_and_account_id", unique: true
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name"
    t.string "plan_id"
    t.string "subscription_key"
    t.string "stripe_price_id"
    t.string "apikey"
    t.string "token"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_options", force: :cascade do |t|
    t.integer "plan_id"
    t.string "interval", null: false
    t.integer "price_cents", null: false
    t.string "stripe_price_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["plan_id", "interval"], name: "index_billing_options_on_plan_id_and_interval", unique: true
  end

  create_table "custom_forms", force: :cascade do |t|
    t.string "name"
    t.integer "project_id"
    t.string "description"
    t.string "apikey"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_custom_forms_on_apikey"
  end

  create_table "form_field_children", force: :cascade do |t|
    t.integer "form_field_id"
    t.string "name"
    t.string "field_id"
    t.integer "order_num"
    t.string "apikey"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_form_field_children_on_apikey"
  end

  create_table "form_fields", force: :cascade do |t|
    t.integer "custom_form_id"
    t.string "name"
    t.string "field_id"
    t.string "field_type"
    t.integer "col_width"
    t.boolean "required", default: false
    t.string "placeholder"
    t.boolean "label_as_placeholder", default: false
    t.integer "order_num"
    t.string "apikey"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_form_fields_on_apikey"
  end

  create_table "form_submissions", force: :cascade do |t|
    t.integer "custom_form_id"
    t.string "raw_data"
    t.string "apikey"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_form_submissions_on_apikey"
  end

  create_table "plans", force: :cascade do |t|
    t.string "slug"
    t.string "name"
    t.integer "submissions_per_month"
    t.integer "emails_per_month"
    t.integer "forms_count"
    t.integer "users_count"
    t.jsonb "features", default: {}
    t.string "apikey"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_plans_on_apikey"
  end

  create_table "projects", force: :cascade do |t|
    t.integer "account_id"
    t.string "name"
    t.string "apikey"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_projects_on_apikey"
  end

  create_table "users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.string "mobile"
    t.string "password_hash"
    t.string "password_salt"
    t.string "password_reset_key"
    t.datetime "password_reset_expires"
    t.datetime "last_active", default: -> { "CURRENT_TIMESTAMP" }
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "state"
    t.string "postal"
    t.string "gsi_pic"
    t.string "gsi_sub"
    t.string "apikey"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["apikey"], name: "index_users_on_apikey"
  end

end
