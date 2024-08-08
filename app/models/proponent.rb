class Proponent < ApplicationRecord

  validates :name, presence: true
  validates :cpf, presence: true, uniqueness: true
  validates :birthday, presence: true
  validates :street, presence: true
  validates :number, presence: true
  validates :district, presence: true
  validates :city, presence: true
  validates :state, presence: true
  validates :cep, presence: true
  validates :phones, presence: true
  validates :wage, presence: true

end
