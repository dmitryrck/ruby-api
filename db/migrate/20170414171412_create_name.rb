class CreateName < ActiveRecord::Migration[5.0]
  def change
    create_table :name do |t|
      t.string :name, null: false
      t.string :imdb_index
      t.integer :imdb_id
      t.string :gender
      t.string :name_pcode_cf
      t.string :name_pcode_nf
      t.string :surname_pcode
      t.string :md5sum
    end
  end
end
