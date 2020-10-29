# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_23_160349) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "bodies", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.uuid "organization_id", null: false
    t.integer "default_votes"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["organization_id"], name: "index_bodies_on_organization_id"
  end

  create_table "bodies_groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "body_id", null: false
    t.uuid "group_id", null: false
    t.integer "votes"
    t.index ["body_id"], name: "index_bodies_groups_on_body_id"
    t.index ["group_id"], name: "index_bodies_groups_on_group_id"
  end

  create_table "groups", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "number"
    t.integer "available_votes", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.uuid "user_id"
    t.uuid "organization_id"
    t.string "email"
    t.index ["name"], name: "index_groups_on_name", unique: true
    t.index ["organization_id"], name: "index_groups_on_organization_id"
    t.index ["user_id"], name: "index_groups_on_user_id", unique: true
  end

  create_table "options", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title"
    t.uuid "question_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["question_id"], name: "index_options_on_question_id"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "questions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "voting_id", null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["voting_id"], name: "index_questions_on_voting_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "auth_token", null: false
    t.datetime "auth_token_expires_at", null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "role", default: 0, null: false
    t.uuid "organization_id"
    t.index ["auth_token"], name: "index_users_on_auth_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "vote_submissions", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "group_id", null: false
    t.uuid "voting_id", null: false
    t.integer "votes_submitted"
    t.index ["group_id", "voting_id"], name: "index_vote_submissions_on_group_id_and_voting_id", unique: true
    t.index ["group_id"], name: "index_vote_submissions_on_group_id"
    t.index ["voting_id"], name: "index_vote_submissions_on_voting_id"
  end

  create_table "votes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "option_id", null: false
    t.uuid "group_id"
    t.index ["group_id"], name: "index_votes_on_group_id"
    t.index ["option_id"], name: "index_votes_on_option_id"
  end

  create_table "votings", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "title", null: false
    t.string "description"
    t.integer "status", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "secret", default: false, null: false
    t.string "type", default: "SimpleVoting", null: false
    t.integer "max_options"
    t.uuid "organization_id"
    t.integer "timeout_in_seconds"
    t.datetime "finishes_at"
    t.uuid "body_id"
    t.index ["body_id"], name: "index_votings_on_body_id"
    t.index ["organization_id"], name: "index_votings_on_organization_id"
  end

  add_foreign_key "bodies", "organizations"
  add_foreign_key "bodies_groups", "bodies"
  add_foreign_key "bodies_groups", "groups"
  add_foreign_key "groups", "organizations"
  add_foreign_key "groups", "users"
  add_foreign_key "options", "questions"
  add_foreign_key "questions", "votings"
  add_foreign_key "users", "organizations"
  add_foreign_key "vote_submissions", "groups"
  add_foreign_key "vote_submissions", "votings"
  add_foreign_key "votes", "groups"
  add_foreign_key "votes", "options"
  add_foreign_key "votings", "bodies"
  add_foreign_key "votings", "organizations"
end
