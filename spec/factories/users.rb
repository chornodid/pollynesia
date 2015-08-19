FactoryGirl.define do
  factory :user do
    firstname { Faker::Name.first_name }
    lastname { Faker::Name.last_name }
    email { Faker::Internet.email }
    password { SecureRandom.uuid }
    password_confirmation { password }

    factory :admin_user do
      is_admin true
    end
  end
end
