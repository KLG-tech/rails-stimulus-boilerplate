require 'rails_helper'

RSpec.describe UserProvider, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    let(:user) { create(:user) }

    it 'is valid with valid attributes' do
      user_provider = UserProvider.new(user: user)
      expect(user_provider).to be_valid
    end

    it 'is invalid without a user' do
      user_provider = UserProvider.new(user: nil)
      expect(user_provider).not_to be_valid
      expect(user_provider.errors[:user]).to include("must exist")
    end
  end

  describe 'database associations' do
    let!(:user) { create(:user) }
    let!(:user_provider) { create(:user_provider, user: user) }

    it 'belongs to a user' do
      expect(user_provider.user).to eq(user)
    end

    it 'is destroyed when user is destroyed' do
      expect { user.destroy }.to change(UserProvider, :count).by(-1)
    end
  end
end
