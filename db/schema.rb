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

ActiveRecord::Schema.define(:version => 20110129093354) do

  create_table "attach_images", :id => false, :force => true do |t|
    t.integer "attachable_id"
    t.string  "attachable_type"
    t.integer "image_id"
    t.boolean "main_img",        :default => false
  end

  add_index "attach_images", ["attachable_id", "attachable_type", "image_id"], :name => "attach_images_uniq", :unique => true

  create_table "background_workers", :force => true do |t|
    t.string   "task_name"
    t.string   "current_status"
    t.integer  "current_item",   :default => 0
    t.integer  "total_items",    :default => 0
    t.integer  "user_id"
    t.text     "log_errors"
    t.datetime "task_end"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", :force => true do |t|
    t.integer  "parent_id"
    t.string   "name",             :limit => 80
    t.boolean  "active",                         :default => true
    t.integer  "sort_order",                     :default => 100
    t.string   "meta"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind",                           :default => 1
    t.string   "permalink",                                         :null => false
    t.integer  "virtual_id"
    t.boolean  "show_description",               :default => false
    t.string   "meta_keywords"
    t.string   "meta_description"
  end

  add_index "categories", ["permalink"], :name => "index_categories_on_permalink", :unique => true

  create_table "commercial_offer_items", :force => true do |t|
    t.integer "commercial_offer_id"
    t.integer "quantity"
    t.integer "lk_product_id"
  end

  create_table "commercial_offers", :force => true do |t|
    t.integer  "firm_id"
    t.integer  "sale",       :default => 0
    t.string   "email"
    t.text     "signature"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lk_firm_id"
  end

  create_table "currency_values", :force => true do |t|
    t.date     "dt"
    t.decimal  "usd",        :precision => 10, :scale => 2, :default => 0.0
    t.decimal  "eur",        :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "firms", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.text     "addr_u"
    t.text     "addr_f"
    t.string   "phone"
    t.string   "email"
    t.string   "url"
    t.boolean  "is_supplier", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "foreign_access", :force => true do |t|
    t.string   "name"
    t.string   "ip_addr"
    t.string   "param_key"
    t.datetime "accepted_from"
    t.datetime "accepted_to"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", :force => true do |t|
    t.string   "type"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lk_firms", :force => true do |t|
    t.integer  "firm_id"
    t.string   "name"
    t.string   "contact"
    t.text     "addr_u"
    t.text     "addr_f"
    t.text     "description"
    t.string   "phone"
    t.string   "email"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lk_order_items", :force => true do |t|
    t.integer  "lk_order_id"
    t.integer  "product_id"
    t.string   "product_type"
    t.integer  "quantity"
    t.decimal  "price",        :precision => 10, :scale => 2, :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lk_orders", :force => true do |t|
    t.integer  "firm_id"
    t.integer  "lk_firm_id"
    t.integer  "status_id",   :default => 0
    t.string   "random_link"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lk_products", :force => true do |t|
    t.integer  "firm_id"
    t.integer  "product_id"
    t.string   "article"
    t.string   "short_name"
    t.text     "description"
    t.decimal  "price",                :precision => 10, :scale => 2, :default => 0.0
    t.string   "color"
    t.string   "size"
    t.string   "factur"
    t.string   "box"
    t.string   "infliction"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "active",                                              :default => true
  end

  create_table "manufactors", :force => true do |t|
    t.string   "name",       :limit => 80
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "product_categories", :id => false, :force => true do |t|
    t.integer "product_id"
    t.integer "category_id"
  end

  add_index "product_categories", ["product_id", "category_id"], :name => "index_product_categories_on_product_id_and_category_id", :unique => true

  create_table "product_properties", :id => false, :force => true do |t|
    t.integer  "property_value_id"
    t.integer  "product_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "product_properties", ["property_value_id", "product_id"], :name => "index_product_properties_on_property_value_id_and_product_id", :unique => true

  create_table "products", :force => true do |t|
    t.integer  "manufactor_id"
    t.integer  "supplier_id"
    t.string   "article",            :limit => 100
    t.string   "short_name",         :limit => 100
    t.string   "full_name",          :limit => 100
    t.string   "size",               :limit => 30
    t.string   "color",              :limit => 20
    t.string   "factur",             :limit => 100
    t.string   "box",                :limit => 30
    t.decimal  "price",                             :precision => 10, :scale => 2, :default => 0.0
    t.integer  "sort_order",                                                       :default => 100
    t.integer  "store_count",                                                      :default => 0
    t.integer  "remote_store_count",                                               :default => 0
    t.boolean  "from_store",                                                       :default => true
    t.boolean  "from_remote_store",                                                :default => false
    t.boolean  "active",                                                           :default => true
    t.text     "description"
    t.string   "meta_description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "currency_type",      :limit => 3
    t.string   "meta_keywords"
    t.string   "permalink",                                                                           :null => false
  end

  add_index "products", ["permalink"], :name => "index_products_on_permalink", :unique => true

  create_table "properties", :force => true do |t|
    t.string   "name",          :limit => 40
    t.boolean  "active",                      :default => true
    t.integer  "sort_order",                  :default => 100
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "property_type",               :default => 0,    :null => false
  end

  create_table "property_categories", :id => false, :force => true do |t|
    t.integer "property_id"
    t.integer "category_id"
  end

  add_index "property_categories", ["property_id", "category_id"], :name => "index_property_categories_on_property_id_and_category_id", :unique => true

  create_table "property_values", :force => true do |t|
    t.integer  "property_id"
    t.string   "value"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string  "name",              :limit => 40
    t.integer "group",                           :default => 0
    t.integer "authorizable_id"
    t.integer "authorizable_type"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  create_table "suppliers", :force => true do |t|
    t.string "name",    :limit => 80
    t.string "address"
  end

  create_table "users", :force => true do |t|
    t.string   "username",          :limit => 30
    t.string   "email",             :limit => 50
    t.string   "crypted_password"
    t.string   "passwort_salt"
    t.string   "persistence_token"
    t.string   "fio",               :limit => 90
    t.string   "phone",             :limit => 40
    t.boolean  "active",                          :default => false
    t.integer  "login_count",                     :default => 0,     :null => false
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date     "expire_date"
    t.integer  "firm_id"
  end

  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end
