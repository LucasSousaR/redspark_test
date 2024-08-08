FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    cnpj { Faker::Company.brazilian_company_number } # Assuming you're using a valid CNPJ format generator

    trait :with_invalid_cnpj do
      cnpj { '12345678901234' } # Example of an invalid CNPJ
    end

    trait :with_valid_cnpj do
      cnpj { Faker::Company.brazilian_company_number }
    end
  end
end