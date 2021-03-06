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

ActiveRecord::Schema.define(version: 20160420131436) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "resource_id"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree

  create_table "shipwire_orders", force: :cascade do |t|
    t.integer  "order_id",           limit: 8
    t.jsonb    "payload"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "order_updated_at"
    t.integer  "common_id",          limit: 8
    t.string   "shopify_id"
    t.string   "fulfillment_status"
    t.float    "subtotal"
    t.float    "shipping_amount"
    t.integer  "units"
    t.float    "total_shipping"
    t.datetime "accepted_at"
    t.datetime "shipped_at"
    t.string   "hold_status"
  end

  create_table "shopify_orders", force: :cascade do |t|
    t.integer  "order_id",           limit: 8
    t.jsonb    "payload"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.datetime "order_updated_at"
    t.integer  "common_id",          limit: 8
    t.string   "shopify_id"
    t.string   "fulfillment_status"
    t.float    "subtotal"
    t.float    "shipping_amount"
    t.integer  "units"
    t.float    "total_shipping"
    t.float    "sub_total"
    t.float    "total"
    t.float    "discount_total"
    t.date     "paid_date"
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.integer  "role"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "xero_invoices", force: :cascade do |t|
    t.string   "shopify_id"
    t.string   "invoice_status"
    t.string   "invoice_type"
    t.float    "amount_due"
    t.string   "shopify_url"
    t.date     "invoice_date"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.string   "invoice_id"
    t.datetime "order_updated_at"
    t.float    "sub_total"
    t.float    "total"
  end


  create_view :combined_orders, materialized: true,  sql_definition: <<-SQL
      SELECT shipwire_orders.id,
      shopify_orders.shopify_id AS shopify_identifier,
      shipwire_orders.shopify_id AS shipwire_identifier,
      xero_invoices.shopify_id AS xero_identifier,
      shopify_orders.id AS shopify_order_id,
      shipwire_orders.id AS shipwire_order_id,
      xero_invoices.id AS xero_invoice_id,
      shopify_orders.fulfillment_status AS shopify_status,
      shipwire_orders.fulfillment_status AS shipwire_status,
      xero_invoices.invoice_status AS xero_status,
      shopify_orders.order_updated_at AS shopify_updated_at,
      shipwire_orders.order_updated_at AS shipwire_updated_at,
      xero_invoices.order_updated_at AS xero_updated_at,
      shopify_orders.total_shipping AS shopify_total_shipping,
      shipwire_orders.total_shipping AS shipwire_total_shipping,
      shopify_orders.sub_total AS shopify_sub_total,
      xero_invoices.sub_total AS xero_sub_total,
      shopify_orders.total AS shopify_total,
      xero_invoices.total AS xero_total,
      shopify_orders.discount_total AS shopify_discount_total,
      shopify_orders.paid_date AS shopify_paid_date,
      shipwire_orders.accepted_at AS shipwire_accepted_at,
      shipwire_orders.shipped_at AS shipwire_shipped_at,
      shipwire_orders.hold_status AS shipwire_hold_status
     FROM ((shipwire_orders
       LEFT JOIN shopify_orders ON (((shipwire_orders.shopify_id)::text ~~* ((shopify_orders.shopify_id)::text || '%'::text))))
       LEFT JOIN xero_invoices ON (((shipwire_orders.shopify_id)::text ~~* ((xero_invoices.shopify_id)::text || '%'::text))));
  SQL

  add_index "combined_orders", ["id"], name: "index_combined_orders_on_id", unique: true, using: :btree

end
