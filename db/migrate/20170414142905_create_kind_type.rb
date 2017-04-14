class CreateKindType < ActiveRecord::Migration[5.0]
  def change
    create_table :kind_type do |t|
      t.string :kind, null: false
    end
  end
end
