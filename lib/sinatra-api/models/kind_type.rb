class KindType < Sequel::Model(:kind_type)
  one_to_one :kind_type, key: :kind_id

  def validate
    super

    errors.add(:kind, "can't be empty") if kind.nil? || kind == ""
  end
end
