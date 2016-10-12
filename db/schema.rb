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

ActiveRecord::Schema.define(version: 20161012143611) do

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

  create_table "counter_machines", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "current_machines", force: :cascade do |t|
  end

  create_table "data", force: :cascade do |t|
    t.time     "timee"
    t.float    "numbere"
    t.string   "typee"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
    t.integer  "machine_id"
    t.date     "datee"
    t.string   "state"
    t.float    "gradient"
    t.integer  "timestampe",    limit: 8
    t.integer  "cont_on_time",  limit: 8
    t.integer  "cont_off_time", limit: 8
  end

  add_index "data", ["machine_id"], name: "index_data_on_machine_id", using: :btree

  create_table "machines", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "threshold"
    t.string   "sheetname"
    t.string   "data_type"
    t.integer  "next_index_excel"
    t.integer  "actable_id"
    t.string   "actable_type"
    t.string   "unique_id"
  end

  create_table "offtimes", force: :cascade do |t|
    t.date     "date"
    t.integer  "minutes"
    t.integer  "machine_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "maximum_cont_on_time"
    t.integer  "maximum_cont_off_time"
    t.string   "timestampe"
    t.float    "efficiency"
  end

  create_table "raw_data", force: :cascade do |t|
    t.date     "date"
    t.time     "timee"
    t.string   "machine_id"
    t.float    "numbere"
    t.string   "typee"
    t.string   "timestampe"
    t.string   "machine_type"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
  end

  add_index "raw_data", ["machine_id"], name: "index_raw_data_on_machine_id", using: :btree
  add_index "raw_data", ["machine_type"], name: "index_raw_data_on_machine_type", using: :btree

  create_table "rpm_machines", force: :cascade do |t|
    t.float "grad"
  end

  create_table "table1", id: false, force: :cascade do |t|
    t.string  "field1"
    t.integer "field2"
  end

  create_table "temperature_machines", force: :cascade do |t|
  end

  create_table "thedata", force: :cascade do |t|
    t.date    "date"
    t.time    "time"
    t.integer "sensor_id"
    t.integer "sensor_type"
    t.float   "sensor_value"
    t.integer "millis"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",      null: false
    t.string   "encrypted_password",     default: "",      null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,       null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.boolean  "recurring",              default: true
    t.string   "period",                 default: "Month"
    t.integer  "cycles",                 default: 12
    t.string   "sheet_name"
    t.boolean  "is_admin"
    t.integer  "next_index_excel",       default: 2
    t.string   "username"
    t.boolean  "send_reports",           default: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "data", "machines"
end
