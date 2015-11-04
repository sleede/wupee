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

ActiveRecord::Schema.define(version: 20151029113107) do

  create_table "messages", force: :cascade do |t|
    t.string   "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "wupee_notification_type_configurations", force: :cascade do |t|
    t.integer  "notification_type_id"
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "value",                default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "wupee_notification_type_configurations", ["notification_type_id"], name: "idx_wupee_notif_type_config_on_notification_type_id"
  add_index "wupee_notification_type_configurations", ["receiver_type", "receiver_id"], name: "idx_wupee_notif_typ_config_on_receiver_type_and_receiver_id"

  create_table "wupee_notification_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "wupee_notification_types", ["name"], name: "index_wupee_notification_types_on_name", unique: true

  create_table "wupee_notifications", force: :cascade do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "attached_object_id"
    t.string   "attached_object_type"
    t.integer  "notification_type_id"
    t.boolean  "is_read",              default: false
    t.boolean  "is_sent",              default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

end
