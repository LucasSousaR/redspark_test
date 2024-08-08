require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should belong_to(:role) }
    it { should belong_to(:company) }
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should validate_presence_of(:password) }
    it { should validate_confirmation_of(:password) }
  end

  describe '#locked?' do
    it 'returns true if locked_at is present' do
      user = create(:user, locked_at: DateTime.now)
      expect(user.locked?).to be(true)
    end

    it 'returns false if locked_at is nil' do
      user = create(:user, locked_at: nil)
      expect(user.locked?).to be(false)
    end
  end
end