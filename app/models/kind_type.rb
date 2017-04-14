class KindType < ApplicationRecord
  self.table_name = "kind_type"

  validates :kind, presence: true
end
