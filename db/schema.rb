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

ActiveRecord::Schema.define(:version => 20110717102712) do

  create_table "authentications", :force => true do |t|
    t.string   "uid",        :null => false
    t.string   "provider",   :null => false
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["uid"], :name => "index_authentications_on_uid"

  create_table "books", :force => true do |t|
    t.string   "asin",                           :null => false
    t.string   "title",                          :null => false
    t.string   "authors",                        :null => false
    t.integer  "pages",       :default => 0,     :null => false
    t.boolean  "is_ebook",    :default => false, :null => false
    t.string   "image_url"
    t.string   "icon_url"
    t.string   "details_url",                    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["asin"], :name => "index_books_on_asin"

  create_table "reading_logs", :force => true do |t|
    t.integer  "user_id"
    t.integer  "book_id"
    t.date     "start_date"
    t.date     "finish_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
  end

end
