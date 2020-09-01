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

ActiveRecord::Schema.define(version: 2020_08_16_040008) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "favorites", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "space_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "space_id"], name: "index_favorites_on_user_id_and_space_id", unique: true
  end

  create_table "owners", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "company_name", null: false
    t.index ["company_name"], name: "index_owners_on_company_name", unique: true
    t.index ["email"], name: "index_owners_on_email", unique: true
    t.index ["reset_password_token"], name: "index_owners_on_reset_password_token", unique: true
  end

  create_table "reservations", force: :cascade do |t|
    t.bigint "space_id", null: false
    t.bigint "user_id", null: false
    t.datetime "start_time", null: false
    t.datetime "end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id", "end_time"], name: "index_reservations_on_space_id_and_end_time", unique: true
    t.index ["space_id", "start_time"], name: "index_reservations_on_space_id_and_start_time", unique: true
    t.index ["space_id"], name: "index_reservations_on_space_id"
    t.index ["user_id"], name: "index_reservations_on_user_id"
  end

  create_table "reviews", force: :cascade do |t|
    t.bigint "space_id", null: false
    t.bigint "user_id", null: false
    t.integer "rate", null: false
    t.text "comment", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_reviews_on_space_id"
    t.index ["user_id"], name: "index_reviews_on_user_id"
  end

  create_table "settings", force: :cascade do |t|
    t.bigint "space_id", null: false
    t.boolean "reject_same_day_reservation", default: false, null: false
    t.boolean "reservation_unacceptable", default: false, null: false
    t.date "reservation_unacceptable_start_date"
    t.date "reservation_unacceptable_end_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["space_id"], name: "index_settings_on_space_id"
  end

  create_table "spaces", force: :cascade do |t|
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.string "phone_number", null: false
    t.integer "hourly_price", null: false
    t.integer "capacity", null: false
    t.time "business_start_time", null: false
    t.time "business_end_time", null: false
    t.integer "postcode", null: false
    t.integer "prefecture_code", null: false
    t.string "address_city", null: false
    t.string "address_street", null: false
    t.string "address_building"
    t.text "description"
    t.jsonb "images"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "latitude"
    t.float "longitude"
    t.index ["address_building"], name: "index_spaces_on_address_building"
    t.index ["address_city"], name: "index_spaces_on_address_city"
    t.index ["address_street"], name: "index_spaces_on_address_street"
    t.index ["business_end_time"], name: "index_spaces_on_business_end_time"
    t.index ["business_start_time"], name: "index_spaces_on_business_start_time"
    t.index ["hourly_price"], name: "index_spaces_on_hourly_price"
    t.index ["owner_id"], name: "index_spaces_on_owner_id"
    t.index ["postcode"], name: "index_spaces_on_postcode"
    t.index ["prefecture_code"], name: "index_spaces_on_prefecture_code"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name", null: false
    t.string "phone_number", null: false
    t.integer "gender", default: 0, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "favorites", "spaces"
  add_foreign_key "favorites", "users"
  add_foreign_key "reservations", "spaces"
  add_foreign_key "reservations", "users"
  add_foreign_key "reviews", "spaces"
  add_foreign_key "reviews", "users"
  add_foreign_key "settings", "spaces"
  add_foreign_key "spaces", "owners"
end
