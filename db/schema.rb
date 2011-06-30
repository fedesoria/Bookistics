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

ActiveRecord::Schema.define(:version => 20110630063513) do

  create_table "books", :force => true do |t|
    t.string   "asin",        :null => false
    t.string   "title",       :null => false
    t.string   "authors",     :null => false
    t.integer  "pages",       :null => false
    t.boolean  "is_ebook",    :null => false
    t.string   "image_url",   :null => false
    t.string   "details_url", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "books", ["asin"], :name => "index_books_on_asin"

end
