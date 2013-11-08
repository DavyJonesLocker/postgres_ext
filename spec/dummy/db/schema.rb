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

ActiveRecord::Schema.define(version: 20131030103303) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "citext"
  enable_extension "hstore"
  enable_extension "isn"
  enable_extension "pg_trgm"

  create_table "people", force: true do |t|
    t.inet     "ip"
    t.cidr     "subnet"
    t.integer  "tag_ids",      array: true
    t.string   "tags",         array: true
    t.text     "biography"
    t.integer  "lucky_number"
    t.numrange "num_range"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "things", force: true do |t|
    t.string   "name"
    t.string   "title",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
