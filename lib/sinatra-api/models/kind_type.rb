class KindType < Sequel::Model(:kind_type)
  one_to_many :titles

  def validate
    super

    errors.add(:kind, "can't be empty") if kind.nil? || kind == ""
  end
end
