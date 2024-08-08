require 'faker'
require 'date'

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
def generate_cpf
  digits = Array.new(9) { rand(0..9) }
  2.times do
    sum = digits.each_with_index.reduce(0) { |sum, (d, i)| sum + d * (digits.size + 1 - i) }
    digits << ((sum * 10) % 11) % 10
  end
  digits.join
end
def generate_random_date(min_age, max_age)
  today = Date.today
  min_date = today - (max_age * 365)
  max_date = today - (min_age * 365)
  rand(min_date..max_date)
end
10.times do
  Proponent.create!(
   name: Faker::Name.name,
   cpf: generate_cpf,
   birthday:  generate_random_date(18, 65),
   street: Faker::Address.street_name,
   number: Faker::Address.building_number,
   district: Faker::Address.community,
   city: Faker::Address.city,
   state: Faker::Address.state,
   cep: Faker::Address.zip_code,
   phones: Faker::PhoneNumber.cell_phone,
   wage: rand(1000..6000) # Gera um número inteiro
  )
end
Role.create!([
               {name: "Admin", code: "admin"},
               {name: "Operacional", code: "operational"}
             ])
Company.create!([{name: "RedSpark", cnpj: "15.533.871/0001-48"},])

User.create!({name: "Admin", birthday: nil, avatar: nil, email: "admin@admin.com.br",password:"developer098", encrypted_password: "$2a$12$k2iyMJbvJgPjHG4lAcga..hRFCaniLd0yEJkO3aGKVWxBeNEFfBaa", reset_password_token: nil, reset_password_sent_at: nil, remember_created_at: nil, sign_in_count: 11, current_sign_in_at: "2024-03-07 16:59:52", last_sign_in_at: "2024-02-18 12:03:58", current_sign_in_ip: "127.0.0.1", last_sign_in_ip: "127.0.0.1", confirmation_token: "YsuivegEnjMe5raoPnNT", confirmed_at: "2023-10-08 01:47:37", confirmation_sent_at: "2023-10-08 01:46:37", unconfirmed_email: nil, failed_attempts: 0, unlock_token: nil, locked_at: nil, role_id: 1, company_id: 1})

