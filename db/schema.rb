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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110727153538) do

  create_table "classifieds", :force => true do |t|
    t.boolean  "offered"
    t.string   "category"
    t.text     "title"
    t.text     "description"
    t.integer  "placer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.string   "url"
    t.float    "fee"
    t.string   "fee_description"
    t.string   "location"
    t.float    "lon"
    t.float    "lat"
    t.datetime "created_at"
  end

  create_table "members", :force => true do |t|
    t.string   "twitter_id"
    t.string   "name"
    t.string   "username"
    t.string   "picture"
    t.string   "location"
    t.string   "website"
    t.string   "bio"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "entity"
    t.string   "work_location"
    t.text     "platforms_as_string"
    t.text     "job_offers_url"
    t.boolean  "available_for_hire"
    t.text     "work_types_as_string"
    t.string   "role",                 :default => "member"
    t.boolean  "marked_as_spam",       :default => false
    t.boolean  "as_new",               :default => true
  end

  create_table "spam_reports", :force => true do |t|
    t.integer  "member_id"
    t.integer  "reporter_id"
    t.string   "ip_address"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
