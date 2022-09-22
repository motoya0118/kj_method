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

ActiveRecord::Schema.define(version: 2022_09_22_040731) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.string "answer", null: false
    t.bigint "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
  end

  create_table "cards", force: :cascade do |t|
    t.bigint "small_group_id", null: false
    t.string "content", default: "Card"
    t.integer "position", default: 0, null: false
    t.boolean "edit", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["small_group_id"], name: "index_cards_on_small_group_id"
  end

  create_table "large_groups", force: :cascade do |t|
    t.bigint "place_id", null: false
    t.string "name", default: "LargeGroup"
    t.integer "position", default: 0
    t.boolean "edit", default: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["place_id"], name: "index_large_groups_on_place_id"
  end

  create_table "places", force: :cascade do |t|
    t.boolean "public", default: false, null: false
    t.bigint "thema_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thema_id"], name: "index_places_on_thema_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "question", null: false
    t.bigint "thema_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["thema_id"], name: "index_questions_on_thema_id"
  end

  create_table "small_groups", force: :cascade do |t|
    t.bigint "large_group_id", null: false
    t.string "name", default: "SmallGroup", null: false
    t.integer "position", default: 0, null: false
    t.boolean "edit", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["large_group_id"], name: "index_small_groups_on_large_group_id"
  end

  create_table "themas", force: :cascade do |t|
    t.string "name", null: false
    t.string "purpose"
    t.boolean "lock", default: false, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "cards", "small_groups"
  add_foreign_key "large_groups", "places"
  add_foreign_key "places", "themas"
  add_foreign_key "questions", "themas"
  add_foreign_key "small_groups", "large_groups"
end
