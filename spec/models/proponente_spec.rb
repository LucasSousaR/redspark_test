require 'rails_helper'


RSpec.describe Proponente, type: :model do
  it "is valid with valid attributes" do
    proponente = Proponente.new(
      nome: "John Doe",
      cpf: "12345678900",
      data_nascimento: "2000-01-01",
      logradouro: "Rua A",
      numero: "123",
      bairro: "Bairro B",
      cidade: "Cidade C",
      estado: "Estado D",
      cep: "12345-678",
      telefones: "1234567890",
      salario: 3000.00,
      desconto_inss: 281.62
    )
    expect(proponente).to be_valid
  end

  it "is not valid without a nome" do
    proponente = Proponente.new(nome: nil)
    expect(proponente).not_to be_valid
  end


end