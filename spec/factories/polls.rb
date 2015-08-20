FactoryGirl.define do
  factory :poll do
    association(:user)
    title { Faker::Lorem.sentence }
  end
end
