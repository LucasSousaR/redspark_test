class Company < ApplicationRecord
  has_paper_trail

  validates :name, presence: true
  validates :cnpj, presence: true, uniqueness: true, length: { is: 14 }

  has_many :users




end
