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

ActiveRecord::Schema[7.1].define(version: 2024_05_16_013548) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "vector"

  create_table "development_issues", force: :cascade do |t|
    t.string "key"
    t.string "title", null: false
    t.string "assignee"
    t.datetime "issue_updated_at"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.vector "embedding_description_mxbai_embed_large"
    t.vector "embedding_title_mxbai_embed_large"
    t.vector "embedding_description_text_embedding_ada_002"
    t.vector "embedding_title_text_embedding_ada_002"
    t.index ["assignee"], name: "index_development_issues_on_assignee"
    t.index ["key"], name: "index_development_issues_on_key", unique: true
  end

end
