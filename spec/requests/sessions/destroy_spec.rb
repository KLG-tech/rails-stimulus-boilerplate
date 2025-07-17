# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SessionsController#destroy', type: :request do
  let(:user) { create(:user) }

  context 'when user is not signed in' do
    it 'redirects to login' do
      delete sessions_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when user is signed in' do
    before { sign_in user }

    context 'and keycloak is enabled' do
      before do
        allow(Rails.application.config.x.keycloak).to receive(:enabled).and_return(true)
      end

      it 'redirected to root path on sign_out' do
        delete sessions_path

        query_params = {
          client_id: ENV["KEYCLOAK_CLIENT_ID"],
          client_secret: ENV["KEYCLOAK_CLIENT_SECRET"],
          post_logout_redirect_uri: request.base_url
        }

        expect(response).to redirect_to("#{ENV['KEYCLOAK_URL']}/realms/#{ENV['KEYCLOAK_REALM']}/protocol/openid-connect/logout?#{query_params.to_query}")
      end
    end

    context 'and keycloak is disabled' do
      before do
        allow(Rails.application.config.x.keycloak).to receive(:enabled).and_return(false)
      end

      it 'responds with 204 No Content' do
        delete sessions_path
        expect(response).to have_http_status(:no_content).or have_http_status(:ok)
      end
    end
  end
end
