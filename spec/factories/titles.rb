FactoryGirl.define do
  factory :ghost_in_the_shell, class: Title do
    title "Ghost in the Shell"
    kind_id 1
    production_year 2017
    association :kind, factory: :movie

    factory :logan do
      title "Logan"
    end
  end
end
