class Title < Sequel::Model(:title)
  def validate
    super

    %i[title kind_id production_year].each do |attribute|
      errors.add(attribute, "can't be empty") if send(attribute).nil? || send(attribute) == ""
    end
  end
end
