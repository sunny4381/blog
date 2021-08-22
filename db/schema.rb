# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2021_08_22_073854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "sessions", force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "share_closures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "parent_id", null: false
    t.uuid "child_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_share_closures_on_child_id"
    t.index ["parent_id", "child_id"], name: "index_share_closures_on_parent_id_and_child_id", unique: true
    t.index ["parent_id"], name: "index_share_closures_on_parent_id"
  end

  create_table "shares", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_id", null: false
    t.string "type", null: false
    t.string "name", null: false
    t.integer "size"
    t.integer "depth", null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id"], name: "index_shares_on_tenant_id"
  end

  create_table "sys_group_closures", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "parent_id", null: false
    t.uuid "child_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["child_id"], name: "index_sys_group_closures_on_child_id"
    t.index ["parent_id", "child_id"], name: "index_sys_group_closures_on_parent_id_and_child_id", unique: true
    t.index ["parent_id"], name: "index_sys_group_closures_on_parent_id"
  end

  create_table "sys_group_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "group_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["group_id", "user_id"], name: "index_sys_group_users_on_group_id_and_user_id", unique: true
    t.index ["group_id"], name: "index_sys_group_users_on_group_id"
    t.index ["user_id"], name: "index_sys_group_users_on_user_id"
  end

  create_table "sys_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_id", null: false
    t.string "gid", null: false
    t.string "name", null: false
    t.integer "depth", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id", "gid"], name: "index_sys_groups_on_tenant_id_and_gid", unique: true
    t.index ["tenant_id"], name: "index_sys_groups_on_tenant_id"
  end

  create_table "sys_tenants", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.text "memo"
    t.datetime "enabled_at", precision: 6
    t.datetime "disabled_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "brand_name"
    t.index ["name"], name: "index_sys_tenants_on_name", unique: true
  end

  create_table "sys_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "tenant_id", null: false
    t.string "uid", null: false
    t.string "name", null: false
    t.string "password_digest"
    t.string "email"
    t.string "title"
    t.datetime "enabled_at"
    t.datetime "disabled_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["tenant_id", "uid"], name: "index_sys_users_on_tenant_id_and_uid", unique: true
    t.index ["tenant_id"], name: "index_sys_users_on_tenant_id"
  end

  create_table "sys_virtual_hosts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "parent_type"
    t.uuid "parent_id"
    t.string "host", null: false
    t.string "path", null: false
    t.integer "depth"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["parent_type", "parent_id"], name: "index_sys_virtual_hosts_on_parent"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
