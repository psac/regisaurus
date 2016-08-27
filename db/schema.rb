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

ActiveRecord::Schema.define(:version => 20160723133353) do

  create_table "invoices", :force => true do |t|
    t.integer  "cash",       :default => 0
    t.integer  "check",      :default => 0
    t.integer  "points",     :default => 0
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "paid",       :default => false
    t.integer  "match_id"
    t.integer  "discounts",  :default => 0
  end

  create_table "matches", :force => true do |t|
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.string   "title"
    t.string   "club"
    t.string   "club_id"
    t.boolean  "active",     :default => false
  end

  create_table "registrations", :force => true do |t|
    t.integer  "shooter_id"
    t.integer  "match_id"
    t.integer  "fee"
    t.integer  "paid"
    t.text     "notes"
    t.string   "division"
    t.string   "power_factor"
    t.integer  "squad"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "invoice_id"
    t.boolean  "join_psac",    :default => false
  end

  create_table "shooters", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "uspsa_number"
    t.string   "gender"
    t.string   "age"
    t.string   "member"
    t.string   "agc_number"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.boolean  "lady"
    t.boolean  "military"
    t.boolean  "law"
    t.boolean  "agc_member",   :default => false
    t.date     "waiver"
    t.string   "club_board"
  end

  create_table "users", :force => true do |t|
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true

end
