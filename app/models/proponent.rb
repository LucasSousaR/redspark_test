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
  validates :phone, presence: true
  validates :wage, presence: true


  scope :name_or_cpf_cont, -> (enum = '') {
    order("#{enum}": :asc)
  }
  def self.ransackable_scopes(auth_object = nil)
    %i(name_or_cpf_cont)
  end
end
