class CreateTitles < ActiveRecord::Migration[5.0]
  def change
    create_table :title do |t|
      t.text :title, null: false
      t.string :imdb_index
      t.integer :kind_id, null: false
      t.integer :production_year
      t.integer :imdb_id
      t.string :phonetic_code
      t.integer :episode_of_id
      t.integer :season_nr
      t.integer :episode_nr
      t.string :series_years
      t.string :md5sum
    end
  end
end
