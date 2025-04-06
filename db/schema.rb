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

ActiveRecord::Schema[7.1].define(version: 2025_04_06_215129) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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

  create_table "image_descriptions", force: :cascade do |t|
    t.bigint "onsen_id", null: false
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onsen_id"], name: "index_image_descriptions_on_onsen_id"
  end

  create_table "messages", force: :cascade do |t|
    t.bigint "room_id", null: false
    t.bigint "user_id", null: false
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "parent_message_id"
    t.datetime "editable_until"
    t.index ["parent_message_id"], name: "index_messages_on_parent_message_id"
    t.index ["room_id"], name: "index_messages_on_room_id"
    t.index ["user_id"], name: "index_messages_on_user_id"
  end

  create_table "onsens", force: :cascade do |t|
    t.string "name", null: false
    t.string "location"
    t.text "description"
    t.string "image"
    t.text "activities"
    t.string "best_time_to_visit"
    t.text "access_info"
    t.decimal "rating", precision: 2, scale: 1
    t.integer "user_id", null: false
    t.integer "saved_by_user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.index ["saved_by_user_id"], name: "index_onsens_on_saved_by_user_id"
    t.index ["user_id"], name: "index_onsens_on_user_id"
  end

  create_table "onsens_water_qualities", force: :cascade do |t|
    t.bigint "onsen_id", null: false
    t.bigint "water_quality_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onsen_id", "water_quality_id"], name: "index_onsens_water_qualities_on_onsen_id_and_water_quality_id", unique: true
    t.index ["onsen_id"], name: "index_onsens_water_qualities_on_onsen_id"
    t.index ["water_quality_id"], name: "index_onsens_water_qualities_on_water_quality_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.bigint "onsen_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onsen_id"], name: "index_rooms_on_onsen_id"
  end

  create_table "saved_onsens", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "onsen_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["onsen_id"], name: "index_saved_onsens_on_onsen_id"
    t.index ["user_id"], name: "index_saved_onsens_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "avatar"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "water_qualities", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "image_descriptions", "onsens"
  add_foreign_key "messages", "messages", column: "parent_message_id"
  add_foreign_key "messages", "rooms"
  add_foreign_key "messages", "users"
  add_foreign_key "onsens", "users"
  add_foreign_key "onsens_water_qualities", "onsens"
  add_foreign_key "onsens_water_qualities", "water_qualities"
  add_foreign_key "rooms", "onsens"
  add_foreign_key "saved_onsens", "onsens"
  add_foreign_key "saved_onsens", "users"
end
