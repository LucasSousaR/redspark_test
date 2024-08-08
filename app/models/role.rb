class Role < ApplicationRecord

  has_many :users
  validates :name, presence: true
  validates :code, presence: true, uniqueness: true

  before_save do
    self.code = name.parameterize(separator: '_') if code.blank?
  end
end
