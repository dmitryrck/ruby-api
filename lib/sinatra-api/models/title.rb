class Title < Sequel::Model(:title)
  PERMITTED_PARAMS = %w[title production_year kind_id]

  many_to_one :kind_type, key: :kind_id, allow_eager: true

  def validate
    super

    %i[title kind_id production_year].each do |attribute|
      errors.add(attribute, "can't be empty") if send(attribute).nil? || send(attribute) == ""
    end
  end
end
