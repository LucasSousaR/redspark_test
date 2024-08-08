require 'rails_helper'

RSpec.describe Company, type: :model do
  describe 'associations' do
    it { should have_many(:users) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:cnpj) }
    it { should validate_uniqueness_of(:cnpj) }
    it { should validate_length_of(:cnpj).is_equal_to(14) }
  end
end