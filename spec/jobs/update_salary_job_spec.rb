require 'rails_helper'

RSpec.describe UpdateSalaryJob, type: :job do
  let(:proponent) { create(:proponent, wage: 2000) }

  it "updates the salary and INSS discount of the proponente" do
    described_class.perform_now(proponent.id, 3000)
    proponent.reload
    expect(proponent.wage).to eq(3000)
    expect(proponent.discount_inss).to eq(281.62)
  end
end