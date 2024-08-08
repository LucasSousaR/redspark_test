FactoryBot.define do
  factory :role do
    name { Faker::Job.title }
    code { Faker::Code.asin }
  end
end