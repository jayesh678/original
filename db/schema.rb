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

ActiveRecord::Schema[7.1].define(version: 2024_02_27_141313) do
  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "business_partners", force: :cascade do |t|
    t.string "customer_name"
    t.string "customer_code"
    t.integer "corporate_number"
    t.integer "invoice_number"
    t.string "address"
    t.integer "postal_code"
    t.integer "telephone_number"
    t.string "bank_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "vendor_master_id"
    t.index ["vendor_master_id"], name: "index_business_partners_on_vendor_master_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.string "category_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string "company_name"
    t.string "company_code"
    t.string "company_uniqueid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", force: :cascade do |t|
    t.float "amount"
    t.float "tax_amount"
    t.date "date_of_application"
    t.string "description"
    t.integer "number_of_people"
    t.date "expense_date"
    t.string "receipt"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id", null: false
    t.integer "business_partner_id", null: false
    t.integer "user_id", null: false
    t.string "application_number"
    t.integer "status", default: 0
    t.string "source"
    t.string "destination"
    t.integer "flow_id"
    t.integer "initiator_id"
    t.integer "subcategory_id"
    t.float "total_amount"
    t.string "application_name"
    t.index ["business_partner_id"], name: "index_expenses_on_business_partner_id"
    t.index ["category_id"], name: "index_expenses_on_category_id"
    t.index ["flow_id"], name: "index_expenses_on_flow_id"
    t.index ["subcategory_id"], name: "index_expenses_on_subcategory_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "flows", force: :cascade do |t|
    t.string "flow_levels"
    t.integer "user_assigned_id"
    t.integer "assigned_user_id"
    t.date "start_date"
    t.date "end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles", force: :cascade do |t|
    t.string "role_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  create_table "subcategories", force: :cascade do |t|
    t.string "name"
    t.integer "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_subcategories_on_category_id"
  end

  create_table "travel_expenses", force: :cascade do |t|
    t.float "amount"
    t.float "tax_amount"
    t.integer "application_number"
    t.string "description"
    t.date "date"
    t.integer "number_of_people"
    t.date "expense_date"
    t.string "receipt"
    t.integer "status"
    t.string "source"
    t.string "destination"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "category_id", null: false
    t.index ["category_id"], name: "index_travel_expenses_on_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "firstname"
    t.string "lastname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "company_id"
    t.integer "role_id"
    t.string "user_code"
    t.index ["company_id"], name: "index_users_on_company_id"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_users_on_role_id"
  end

  create_table "vendor_masters", force: :cascade do |t|
    t.string "customer_name"
    t.string "customer_code"
    t.integer "corporate_number"
    t.integer "invoice_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "business_partners", "vendor_masters"
  add_foreign_key "expenses", "business_partners"
  add_foreign_key "expenses", "categories"
  add_foreign_key "expenses", "flows"
  add_foreign_key "expenses", "subcategories"
  add_foreign_key "expenses", "users"
  add_foreign_key "subcategories", "categories"
  add_foreign_key "travel_expenses", "categories"
  add_foreign_key "users", "companies"
  add_foreign_key "users", "roles"
end
