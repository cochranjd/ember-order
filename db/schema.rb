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

ActiveRecord::Schema.define(version: 20140904125601) do

  create_table "menuitems", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "price_in_cents"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", force: true do |t|
    t.string   "email"
    t.string   "token"
    t.string   "invitees"
    t.string   "status"
    t.string   "container_id"
    t.boolean  "is_master"
    t.integer  "total_price_in_cents"
    t.string   "cc_number"
    t.string   "cc_expire"
    t.string   "cc_name"
    t.boolean  "is_paid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "selections", force: true do |t|
    t.integer  "order_id"
    t.integer  "menuitem_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "selections", ["menuitem_id"], name: "index_selections_on_menuitem_id"
  add_index "selections", ["order_id"], name: "index_selections_on_order_id"

end
