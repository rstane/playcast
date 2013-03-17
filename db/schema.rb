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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130315064057) do

  create_table "admin_users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true

  create_table "boards", :force => true do |t|
    t.integer  "plan_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "boards", ["plan_id"], :name => "index_boards_on_plan_id"

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "sort"
  end

  create_table "categorizes", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "category_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "cheers", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.integer  "board_id"
  end

  create_table "entries", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.text     "comment"
  end

  create_table "favorites", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feeds", :force => true do |t|
    t.string   "type"
    t.integer  "user_id"
    t.integer  "plan_id"
    t.integer  "entry_id"
    t.integer  "comment_id"
    t.string   "happen"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.datetime "mail_sent_at"
    t.boolean  "send_mail_flag", :default => false
    t.text     "sentence"
  end

  create_table "participations", :force => true do |t|
    t.integer  "user_id"
    t.integer  "plan_id"
    t.integer  "entry_id"
    t.integer  "schedule_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "plans", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "description"
    t.text     "image_url"
    t.text     "place"
    t.string   "budget"
    t.integer  "min_people"
    t.integer  "max_people"
    t.datetime "publish_start_at"
    t.datetime "publish_end_at"
    t.text     "target_people"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.boolean  "decide_flag",      :default => false
    t.boolean  "entry_close_flag", :default => false
    t.integer  "index"
    t.integer  "number"
    t.integer  "cheers_count",     :default => 0
    t.integer  "favorites_count",  :default => 0
    t.string   "area"
    t.integer  "male_min",         :default => 2
    t.integer  "male_max"
    t.integer  "female_min",       :default => 2
    t.integer  "female_max"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 5
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "schedules", :force => true do |t|
    t.integer  "plan_id"
    t.datetime "candidate_day"
    t.boolean  "adopt_flag",    :default => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "number"
    t.datetime "close_at"
  end

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "name"
    t.string   "nickname"
    t.string   "image"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "email"
    t.string   "location"
    t.string   "slug"
    t.string   "gender"
  end

  add_index "users", ["slug"], :name => "index_users_on_slug", :unique => true

  create_table "will_entries", :force => true do |t|
    t.integer  "plan_id"
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "will_entries", ["plan_id"], :name => "index_will_entries_on_plan_id"
  add_index "will_entries", ["user_id"], :name => "index_will_entries_on_user_id"

end
