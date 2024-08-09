# frozen_string_literal: true

class HomeController < ApplicationController
  # GET /
  def index
    @tracks = {
      'Até R$ 1.045,00' => Proponent.where('wage <= ?', 1045.00).count,
      'De R$ 1.045,01 a R$ 2.089,60' => Proponent.where('wage > ? AND wage <= ?', 1045.00, 2089.60).count,
      'De R$ 2.089,61 até R$ 3.134,40' => Proponent.where('wage > ? AND wage <= ?', 2089.60, 3134.40).count,
      'De R$ 3.134,41 até R$ 6.101,06' => Proponent.where('wage > ? AND wage <= ?', 3134.40, 6101.06).count
    }
  end
end
