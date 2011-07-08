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

ActiveRecord::Schema.define(:version => 20110708112814) do

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
    t.text     "platforms"
    t.text     "job_offers_url"
    t.boolean  "available_for_hire"
  end

end
