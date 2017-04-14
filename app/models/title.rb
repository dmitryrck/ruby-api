class Title < ApplicationRecord
  self.table_name = "title"

  belongs_to :kind, class_name: "KindType"

  validates :title, :kind_id, :production_year, presence: true
end
