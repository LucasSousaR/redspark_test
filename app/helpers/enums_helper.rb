module EnumsHelper


  def error_code
    %w(BAD_REQUEST CONFLICT NOT_FOUND UNAUTHORIZED)
  end

  def gender
    %w(FEMININO MASCULINO)
  end

  def state
    %w(AC AL AP AM BA CE DF ES GO MA MT MS MG PA PB PR PE PI RJ RN RS RO RR SC SP SE TO)
  end

  def city
  end

  def urgency
    [
      ['Urgente', 'URGENT'],
      ['Normal', 'NORMAL'],
      ['Agendado', 'SCHEDULED'],
    # Adicione outras opções aqui conforme necessário
    ]
  end



end
