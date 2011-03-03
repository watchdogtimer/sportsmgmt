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

ActiveRecord::Schema.define(:version => 20081206211036) do

  create_table "abilities", :force => true do |t|
    t.integer  "level"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "authorized_models", :force => true do |t|
    t.integer  "model_id"
    t.string   "model_type"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_sets", :force => true do |t|
    t.integer  "league_id"
    t.integer  "team_id"
    t.integer  "opponent_id"
    t.datetime "time"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_sets_teams", :force => true do |t|
    t.integer  "game_set_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "games", :force => true do |t|
    t.datetime "time"
    t.integer  "game_set_id"
    t.integer  "league_id"
    t.integer  "team_id"
    t.integer  "opponent_id"
    t.integer  "game_in_set"
    t.integer  "score"
    t.integer  "opponent_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "leagues", :force => true do |t|
    t.integer  "organization_id"
    t.text     "paypal_form_text"
    t.text     "description"
    t.text     "check_info_text"
    t.boolean  "locked"
    t.integer  "player_cap"
    t.boolean  "active"
    t.string   "name"
    t.string   "game_type"
    t.date     "reg_date"
    t.float    "reg_fee"
    t.date     "late_reg_date"
    t.float    "late_reg_fee"
    t.date     "close_reg_date"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "missed_games", :force => true do |t|
    t.integer  "registration_id"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organizations", :force => true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "registrations", :force => true do |t|
    t.integer  "player_id"
    t.integer  "league_id"
    t.integer  "team_info"
    t.string   "team_name"
    t.string   "missed_games"
    t.string   "shirt_size"
    t.string   "payment_type"
    t.string   "payment_status"
    t.boolean  "captain"
    t.boolean  "volunteer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles", :force => true do |t|
    t.string   "title",             :limit => 40
    t.string   "authorizable_type", :limit => 40
    t.integer  "authorizable_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer  "user_id"
    t.integer  "role_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_games", :force => true do |t|
    t.integer  "team_score"
    t.integer  "opponent_score"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_memberships", :force => true do |t|
    t.integer  "player_id"
    t.integer  "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "teams", :force => true do |t|
    t.string   "name"
    t.string   "skill_level"
    t.integer  "league_id"
    t.integer  "organizer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "throw_levels", :force => true do |t|
    t.integer  "level"
    t.string   "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "type"
    t.string   "login",                               :null => false
    t.string   "crypted_password",                    :null => false
    t.string   "password_salt",                       :null => false
    t.string   "persistence_token",   :default => "", :null => false
    t.string   "single_access_token",                 :null => false
    t.string   "perishable_token",                    :null => false
    t.integer  "login_count",         :default => 0,  :null => false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "gender"
    t.integer  "age"
    t.integer  "ability_id"
    t.integer  "throw_level_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
