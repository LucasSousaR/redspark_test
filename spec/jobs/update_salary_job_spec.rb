require 'rails_helper'

RSpec.describe AtualizaSalarioJob, type: :job do
  let(:proponente) { create(:proponente, salario: 2000) }

  it "updates the salary and INSS discount of the proponente" do
    described_class.perform_now(proponente.id, 3000)
    proponente.reload
    expect(proponente.salario).to eq(3000)
    expect(proponente.desconto_inss).to eq(281.62)
  end
end