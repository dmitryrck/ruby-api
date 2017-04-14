FactoryGirl.define do
  factory :john, class: Name do
    name "John"
    md5sum { SecureRandom.hex }
  end
end
