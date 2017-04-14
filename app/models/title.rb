class Title < ApplicationRecord
  self.table_name = "title"

  validates :title, :kind_id, :production_year, presence: true
end
