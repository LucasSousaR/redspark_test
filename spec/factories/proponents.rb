FactoryBot.define do
  factory :proponent do
    name { "John Doe" }
    cpf { "12345678900" }
    birthday { "2000-01-01" }
    street { "Rua A" }
    number { "123" }
    district { "Bairro B" }
    city { "Cidade C" }
    state { "Estado D" }
    cep { "12345-678" }
    phone { "1234567890" }
    wage { 3000.00 }
    discount_inss { 281.62 }
  end
end