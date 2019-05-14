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

ActiveRecord::Schema.define(version: 2019_05_14_084120) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "product_settings", force: :cascade do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number_of_items_to_load"
    t.text "filter_order"
    t.boolean "include_out_of_stock_products", default: true
    t.boolean "related_search_on", default: true
    t.boolean "autoscroll_on", default: true
    t.string "load_more_text"
    t.boolean "overflow_scroll_on", default: true
    t.boolean "true_filter_on", default: true
    t.boolean "true_search_on", default: true
  end

  create_table "product_synonyms", force: :cascade do |t|
    t.string "synonym"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "product_setting_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "title"
    t.string "vendor"
    t.string "tags"
    t.string "first_image_url"
    t.string "second_image_url"
    t.float "price"
    t.float "compare_at_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "shopify_id"
    t.string "product_type"
    t.datetime "shopify_created_at"
    t.integer "quantity"
    t.string "slug_url"
  end

  create_table "shops", force: :cascade do |t|
    t.string "shopify_domain", null: false
    t.string "shopify_token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true
  end

  create_table "sizes", force: :cascade do |t|
    t.integer "product_id"
    t.string "title"
    t.integer "inventory_quantity"
    t.string "shopify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_sizes_on_product_id"
  end

end
