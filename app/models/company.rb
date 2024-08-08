class Company < ApplicationRecord
  has_paper_trail

  validates :name, presence: true
  validates :cnpj, presence: true

  has_many :contabil_patterns


  has_many :company_cards, dependent: :destroy
  has_many :cards, through: :company_cards

  private


end
