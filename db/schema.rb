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

ActiveRecord::Schema.define(version: 2020_07_04_100420) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "rooms", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "name", null: false
    t.text "description"
    t.string "image", null: false
    t.integer "postcode", null: false
    t.integer "prefecture_code", null: false
    t.string "address_city", null: false
    t.string "address_street", null: false
    t.string "address_building", null: false
    t.string "phone_number", null: false
    t.integer "hourly_price", null: false
    t.time "business_start_time", null: false
    t.time "business_end_time", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_building"], name: "index_rooms_on_address_building"
    t.index ["address_city"], name: "index_rooms_on_address_city"
    t.index ["address_street"], name: "index_rooms_on_address_street"
    t.index ["business_end_time"], name: "index_rooms_on_business_end_time"
    t.index ["business_start_time"], name: "index_rooms_on_business_start_time"
    t.index ["hourly_price"], name: "index_rooms_on_hourly_price"
    t.index ["owner_id"], name: "index_rooms_on_owner_id"
    t.index ["postcode"], name: "index_rooms_on_postcode"
    t.index ["prefecture_code"], name: "index_rooms_on_prefecture_code"
  end

  add_foreign_key "rooms", "owners"
end
