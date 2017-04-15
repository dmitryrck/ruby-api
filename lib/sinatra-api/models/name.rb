class Name < Sequel::Model(:name)
  def validate
    super

    errors.add(:name, "can't be empty") if name.nil? || name == ""
  end
end
