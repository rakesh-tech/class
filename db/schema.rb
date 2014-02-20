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

ActiveRecord::Schema.define(:version => 20140120145834) do

  create_table "accounts", :force => true do |t|
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "project_files", :force => true do |t|
    t.integer  "project_id"
    t.text     "csv_group"
    t.text     "csv_user"
    t.text     "csv_case"
    t.text     "csv_customer"
    t.text     "csv_note"
    t.text     "csv_reply"
    t.text     "csv_attachment"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.text     "csv_company"
    t.text     "csv_facebook"
    t.text     "csv_twitter"
    t.datetime "company_download_at"
    t.datetime "case_download_at"
    t.datetime "attachment_download_at"
    t.datetime "customer_download_at"
    t.datetime "note_download_at"
    t.datetime "reply_download_at"
    t.datetime "user_download_at"
    t.datetime "facebook_user_download_at"
    t.datetime "twitter_user_download_at"
    t.datetime "group_download_at"
  end

  create_table "projects", :force => true do |t|
    t.string   "support_email"
    t.string   "subdomain"
    t.string   "consumer_key"
    t.string   "consumer_secret"
    t.string   "oauth_token"
    t.string   "oauth_token_secret"
    t.string   "user_id"
    t.string   "name"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "user_name"
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
