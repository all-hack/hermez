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

ActiveRecord::Schema.define(version: 20170624020229) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cadets", force: :cascade do |t|
    t.string "name"
    t.string "login"
    t.datetime "last_mail"
    t.integer "mails_received"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email"
    t.string "image_url"
  end

  create_table "list_selecteds", force: :cascade do |t|
    t.integer "cadet_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "cadet_list"
  end

end
