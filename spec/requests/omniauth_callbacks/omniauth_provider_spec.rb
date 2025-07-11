require 'rails_helper'

RSpec.describe 'Users::OmniauthCallbacksController#omniauth_provider', type: :request do
  before do
    # Configure OmniAuth test mode
    OmniAuth.config.test_mode = true
    Rails.application.env_config['devise.mapping'] = Devise.mappings[:user]
  end

  let(:auth_hash) do
    OmniAuth::AuthHash.new(
      provider: 'keycloak_openid',
      uid: '123456',
      info: { email: 'foo@example.com', name: 'Foo bar' },
      extra: {
        raw_info: {
          custom_attributes: {
            roleapp_access: {
              user_basic_info: {
                email: 'foo@example.com',
                name: 'foo bar',
                nip: '123456'
              }
            }
          }
        }
      }
    )
  end

  context 'when user is persisted' do
    before do
      allow(User).to receive(:from_omniauth).and_return(create(:user, email: 'foo@example.com'))
      OmniAuth.config.mock_auth[:keycloak_openid] = auth_hash
    end

    it 'signs in the user and redirects' do
      get user_keycloak_openid_omniauth_callback_path
      expect(response).to redirect_to(root_path)
    end
  end

  context 'when user is not persisted' do
    before do
      user = build(:user, email: 'test@example.com')
      allow(User).to receive(:from_omniauth).and_return(user)
      OmniAuth.config.mock_auth[:keycloak_openid] = auth_hash
    end

    it 'redirects to registration path' do
      get user_keycloak_openid_omniauth_callback_path
      expect(response).to redirect_to(new_user_registration_url)
    end
  end
end
