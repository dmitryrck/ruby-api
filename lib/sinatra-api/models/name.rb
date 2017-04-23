class Name < Sequel::Model(:name)
  PERMITTED_PARAMS = %w[name md5sum]

  def validate
    super

    errors.add(:name, "can't be empty") if name.nil? || name == ""
  end
end
