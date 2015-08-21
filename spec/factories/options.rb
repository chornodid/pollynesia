FactoryGirl.define do
  factory :option do
    association(:poll)
    title { Faker::Lorem.words(2).join(' ') }
  end
end
