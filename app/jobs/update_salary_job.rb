class AtualizaSalarioJob < ApplicationJob
  queue_as :default

  def perform(proponente_id, novo_salario)
    proponente = Proponente.find(proponente_id)
    proponente.update(salario: novo_salario, desconto_inss: calcular_inss(novo_salario))
  end

  private

  def calcular_inss(salario)
    faixas = [
      { limite: 1045.00, aliquota: 0.075 },
      { limite: 2089.60, aliquota: 0.09 },
      { limite: 3134.40, aliquota: 0.12 },
      { limite: 6101.06, aliquota: 0.14 }
    ]

    desconto = 0
    faixas.each do |faixa|
      if salario > faixa[:limite]
        desconto += (faixa[:limite] - (faixa[:anterior_limite] || 0)) * faixa[:aliquota]
      else
        desconto += (salario - (faixa[:anterior_limite] || 0)) * faixa[:aliquota]
        break
      end
      faixa[:anterior_limite] = faixa[:limite]
    end
    desconto
  end
end
