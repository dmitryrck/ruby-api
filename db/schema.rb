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

ActiveRecord::Schema.define(version: 20170414010108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "title", force: :cascade do |t|
    t.text    "title",           null: false
    t.string  "imdb_index"
    t.integer "kind_id",         null: false
    t.integer "production_year"
    t.integer "imdb_id"
    t.string  "phonetic_code"
    t.integer "episode_of_id"
    t.integer "season_nr"
    t.integer "episode_nr"
    t.string  "series_years"
    t.string  "md5sum"
  end

end
