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

ActiveRecord::Schema[8.1].define(version: 2026_04_22_120700) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "brands", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_brands_on_name", unique: true
  end

  create_table "filaments", force: :cascade do |t|
    t.string "color_hex", null: false
    t.string "color_name", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "product_id", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_filaments_on_product_id"
  end

  create_table "materials", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_materials_on_name", unique: true
  end

  create_table "products", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.datetime "created_at", null: false
    t.bigint "material_id", null: false
    t.string "name", null: false
    t.integer "spool_weight_grams", null: false
    t.datetime "updated_at", null: false
    t.bigint "variant_id", null: false
    t.integer "weight_grams", null: false
    t.index ["brand_id"], name: "index_products_on_brand_id"
    t.index ["material_id"], name: "index_products_on_material_id"
    t.index ["name"], name: "index_products_on_name", unique: true
    t.index ["variant_id"], name: "index_products_on_variant_id"
  end

  create_table "spools", force: :cascade do |t|
    t.string "comment"
    t.datetime "created_at", null: false
    t.bigint "filament_id", null: false
    t.integer "gross_weight_grams"
    t.boolean "ovp", default: false, null: false
    t.boolean "refill_only", default: false, null: false
    t.integer "remaining_weight_grams", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["filament_id"], name: "index_spools_on_filament_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variants", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_variants_on_name", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "event", null: false
    t.bigint "item_id", null: false
    t.string "item_type", null: false
    t.jsonb "object"
    t.jsonb "object_changes"
    t.bigint "transaction_id"
    t.string "whodunnit"
    t.index ["created_at"], name: "index_versions_on_created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
    t.index ["whodunnit"], name: "index_versions_on_whodunnit"
  end

  add_foreign_key "filaments", "products"
  add_foreign_key "products", "brands"
  add_foreign_key "products", "materials"
  add_foreign_key "products", "variants"
  add_foreign_key "spools", "filaments"
end
