# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'DashboardController#index', type: :request do
  let(:user) { create(:user) }

  context 'when not signed in' do
    it 'redirects to the login page' do
      get dashboard_index_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end

  context 'when signed in' do
    before { sign_in user }

    it 'responds with 200 OK' do
      get dashboard_index_path
      expect(response).to have_http_status(:ok)
      expect(response).not_to be_redirect
    end
  end
end
