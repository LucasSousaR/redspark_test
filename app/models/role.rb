class Role < ApplicationRecord

  has_many :users

  before_save do
    self.code = name.parameterize(separator: '_') if code.blank?
  end
end
