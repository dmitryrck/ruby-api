class Name < ApplicationRecord
  self.table_name = "name"

  validates :name, presence: true
end
