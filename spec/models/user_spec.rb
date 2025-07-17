require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:user_providers).dependent(:destroy) }

    it 'has one attached avatar' do
      user = create(:user)
      expect(user).to have_one_attached(:avatar)
    end
  end
  describe '.from_omniauth' do
   context 'when provider is keycloak_openid' do
     let(:auth_data) do
       {
         provider: 'keycloak_openid',
         extra: {
           raw_info: {
             custom_attributes: {
               roleapp_access: {
                 user_basic_info: {
                   email: 'test@example.com',
                   name: 'Test User',
                   nip: '1234567890'
                 }
               }
             }
           }
         }
       }.with_indifferent_access
     end

     it 'creates a new user and user_provider if not exists' do
       expect {
         user = described_class.from_omniauth(auth_data)
         expect(user).to be_persisted
         expect(user.email).to eq('test@example.com')
         expect(user.name).to eq('Test User')
         expect(user.user_providers.first.uid).to eq('1234567890')
       }.to change(User, :count).by(1)
        .and change(UserProvider, :count).by(1)
     end

     it 'returns existing user if already created' do
       existing_user = create(:user, email: 'test@example.com')
       expect {
         user = described_class.from_omniauth(auth_data)
         expect(user.id).to eq(existing_user.id)
       }.to change(User, :count).by(0)
        .and change(UserProvider, :count).by(1)
     end

     it 'raises error when user_basic_info is missing' do
       invalid_auth_data = auth_data.deep_dup
       invalid_auth_data[:extra][:raw_info][:custom_attributes][:roleapp_access][:user_basic_info] = nil

       expect {
         described_class.from_omniauth(invalid_auth_data)
       }.to raise_error('User basic info not found in Keycloak response')
     end

     it 'raises error when email is missing' do
       invalid_auth_data = auth_data.deep_dup
       invalid_auth_data[:extra][:raw_info][:custom_attributes][:roleapp_access][:user_basic_info][:email] = nil

       expect {
         described_class.from_omniauth(invalid_auth_data)
       }.to raise_error('Email is required from provider')
     end
   end

   context 'when provider does not have a handler method' do
     let(:auth_data) { { provider: 'github' } }

     it 'returns nil' do
       expect(described_class.from_omniauth(auth_data)).to be_nil
     end
   end
 end
end
