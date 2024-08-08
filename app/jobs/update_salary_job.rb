class UpdateSalaryJob < ApplicationJob
  queue_as :default

  def perform(proponent_id, new_salary)
    proponent = Proponent.find(proponent_id)
    proponent.update(wage: new_salary, discount_inss: calcular_inss(new_salary))
  end

  private


  def calcular_inss(wage)

    tracks = [
      { limit: 1045.00, aliquot: 0.075 },
      { limit: 2089.60, aliquot: 0.09 },
      { limit: 3134.40, aliquot: 0.12 },
      { limit: 6101.06, aliquot: 0.14 }
    ]

    desconto = 0

    tracks.each do |track|
      if wage > track[:limit]
        desconto += (track[:limit] - (track[:previous_limit] || 0)) * track[:aliquot]
      else
        desconto += (wage - (track[:previous_limit] || 0)) * track[:aliquot]
        break
      end
      track[:previous_limit] = track[:limit]
    end
    desconto
  end
end
