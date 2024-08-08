FactoryBot.define do
  factory :user do
    password = Faker::Internet.password(8)
    name { Faker::Name.name_with_middle }
    email { Faker::Internet.email }
    birthday { Faker::Date.birthday(18, 65) }
    password { password }
    password_confirmation { password }
    role
    company

    trait :with_locked_account do
      locked_at { DateTime.now }
    end

    trait :without_locked_account do
      locked_at { nil }
    end
  end
end
