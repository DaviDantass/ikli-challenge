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

ActiveRecord::Schema[8.1].define(version: 2026_09_02_223000) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "description", null: false
    t.bigint "merchant_id", null: false
    t.datetime "updated_at", null: false
    t.index ["merchant_id", "description"], name: "index_items_on_merchant_id_and_description", unique: true
    t.index ["merchant_id"], name: "index_items_on_merchant_id"
  end

  create_table "merchants", force: :cascade do |t|
    t.string "address", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "address"], name: "index_merchants_on_name_and_address", unique: true
  end

  create_table "purchasers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_purchasers_on_name", unique: true
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "item_id", null: false
    t.bigint "purchaser_id", null: false
    t.integer "quantity", null: false
    t.decimal "unit_price", precision: 10, scale: 2, null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_purchases_on_item_id"
    t.index ["purchaser_id"], name: "index_purchases_on_purchaser_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "name", null: false
    t.string "password_digest", null: false
    t.datetime "updated_at", null: false
    t.index "lower((email)::text)", name: "index_users_on_lower_email", unique: true
  end

  add_foreign_key "items", "merchants"
  add_foreign_key "purchases", "items"
  add_foreign_key "purchases", "purchasers"
end
